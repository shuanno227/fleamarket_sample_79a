class ItemsController < ApplicationController
  before_action :index_category_set, only: :index
  before_action :set_item, only: [:show, :edit, :update, :destroy, :confirm]
  before_action :show_all_instance, only: [:show, :edit, :update, :destroy]
  before_action :set_card, only: [:confirm]
  before_action :login, except: [:index, :show]

  def index
    @items    = Item.includes([:images]).order(created_at: :desc)
    @ladies   = Item.includes(:images).where(category_id: 33..211).order("id DESC")
    @mens     = Item.includes(:images).where(category_id: 226..356).order("id DESC")
    @babies   = Item.includes(:images).where(category_id: 372..490).order("id DESC")
    @interior = Item.includes(:images).where(category_id: 540..633).order("id DESC")
  end

  def new
    if user_signed_in?
      @item = Item.new
      @item.images.new

    else
      redirect_to new_user_session_path
    end
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      @item.images.new
      render :new
    end
  end

  def edit
    unless current_user.id == @item.seller_id
      redirect_to '/'
    end
    @image                 = Image.where(item_id: @item)
    gon.imageLength        = @image.length
    @category_parent_array = Category.where(ancestry: nil)
    grandchild             = @item.category
    child                  = grandchild.parent

    @parent_array = []
    @parent_array << @item.category.parent.parent.name
    @parent_array << @item.category.parent.parent.id

    @category_children_array = Category.where(ancestry: child.ancestry)
    @child_array             = []
    @child_array << child.name
    @child_array << child.id

    @category_grandchildren_array = Category.where(ancestry: grandchild.ancestry)
    @grandchild_array             = []
    @grandchild_array << grandchild.name
    @grandchild_array << grandchild.id
  end

  def update
    grandchild                    = @item.category
    child                         = grandchild.parent
    @category_parent_array        = Category.where(ancestry: nil)
    @category_children_array      = Category.where(ancestry: child.ancestry)
    @category_grandchildren_array = Category.where(ancestry: grandchild.ancestry)
    if item_params[:images_attributes].nil?
      flash.now[:alert] = "更新できませんでした 【画像を１枚以上入れてください】"
      render :edit
    else
      exit_ids = []
      item_params[:images_attributes].each do |a, b|
        exit_ids << item_params[:images_attributes].dig(:"#{a}", :id).to_i
      end
      ids        = Image.where(item_id: params[:id]).map { |image| image.id }
      delete__db = ids - exit_ids
      Image.where(id: delete__db).destroy_all
      @item.touch
      if @item.update(item_params)
        redirect_to item_path
      else
        flash.now[:alert] = '更新できませんでした'
        render :edit
      end
    end
  end


  def show
    @image             = Image.where(item_id: @item)
    @item_grandchildId = Category.find(@item.category_id)
    @item_childId      = @item_grandchildId.parent
    @item_parentId     = Category.find(@item_childId.ancestry)
    @condition         = Condition.find(@item.condition_id)
    @shipping_cost     = ShippingCost.find(@item.shipping_cost_id)
    @shipping_time     = ShippingTime.find(@item.shipping_time_id)
    @prefecture        = Prefecture.find(@item.prefecture_id)
    @price             = @item.price
    gon.imageId        = @image.ids
  end

  def destroy
    if @item.destroy
      flash[:notice] = '商品を削除しました。'
      redirect_to user_path(current_user)
    else
      flash[:alert] = '削除に失敗しました。'
      redirect_to user_path(current_user)
    end
  end

  def search_child
    respond_to do |format|
      format.html
      format.json do
        @children = Category.find(params[:parent_id]).children
        return @children
      end
    end
  end

  def search_grandchild

    respond_to do |format|
      format.html
      format.json do
        @grandchildren = Category.find(params[:child_id]).children
        return @grandchildren
      end
    end
  end

  def select_category_index
    # カテゴリ名を取得するために@categoryにレコードをとってくる
    @category = Category.find_by(id: params[:id])

    # 親カテゴリーを選択していた場合の処理
    if @category.ancestry == nil
      # Categoryモデル内の親カテゴリーに紐づく孫カテゴリーのidを取得
      category = Category.find_by(id: params[:id]).indirect_ids
      # 孫カテゴリーに該当するitemsテーブルのレコードを入れるようの配列を用意
      @items = []
      # find_itemメソッドで処理
      find_item(category)

      # 孫カテゴリーを選択していた場合の処理
    elsif @category.ancestry.include?("/")
      # Categoryモデル内の親カテゴリーに紐づく孫カテゴリーのidを取得
      @items = Item.where(category_id: params[:id])

      # 子カテゴリーを選択していた場合の処理
    else
      category = Category.find_by(id: params[:id]).child_ids
      # 孫カテゴリーに該当するitemsテーブルのレコードを入れるようの配列を用意
      @items = []
      # find_itemメソッドで処理
      find_item(category)
    end
  end

  def confirm
    @image    = @item.images
    @adresses = Address.find(current_user.id)
    # 売り切れ商品に直接パス指定され購入されそうになった時用
    if @item.buyer_id.present?
      flash[:notice] = 'その商品は売り切れです'
      redirect_to '/'
    end
    # すでにクレジットカードが登録しているか？
    if @card.present?
      # 登録している場合,PAY.JPからカード情報を取得する
      # PAY.JPの秘密鍵をセットする。
      Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
      # PAY.JPから顧客情報を取得する。
      customer = Payjp::Customer.retrieve(@card.payjp_id)
      # PAY.JPの顧客情報から、デフォルトで使うクレジットカードを取得する。
      @card_info = customer.cards.retrieve(customer.default_card)
      # クレジットカード情報から表示させたい情報を定義する。
      # クレジットカードの画像を表示するために、カード会社を取得
      @card_brand = @card_info.brand
      # クレジットカードの有効期限を取得

      # クレジットカード会社を取得したので、カード会社の画像をviewに表示させるため、ファイルを指定する。
      case @card_brand
        when 'Visa'
          # 例えば、Pay.jpからとってきたカード情報の、ブランドが"Visa"だった場合は返り値として(画像として登録されている)Visa.pngを返す
          @card_image = 'visa.gif'
        when 'JCB'
          @card_image = 'jcb.gif'
        when 'MasterCard'
          @card_image = 'master.png'
        when 'American Express'
          @card_image = 'amex.gif'
        when 'Diners Club'
          @card_image = 'diners.gif'
        when 'Discover'
          @card_image = 'discover.gif'
      end

      #  viewの記述を簡略化
      ## 有効期限'月'を定義
      @exp_month = @card_info.exp_month.to_s
      ## 有効期限'年'を定義
      @exp_year = @card_info.exp_year.to_s.slice(2, 3)
    end
  end

  private

  def login
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def item_params
    params.require(:item).permit(:image_ids, :name, :price, :description, :condition_id, :shipping_cost_id, :shipping_time_id, :prefecture_id, :category_id, :brand, :buyer_id, :seller_id, images_attributes: [:image, :_destroy, :id]).merge(seller_id: current_user.id, category_id: params[:category_id])
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def show_all_instance
    @user                = User.find(@item.seller_id)
    @images              = Image.where(item_id: params[:id])
    @images_first        = Image.where(item_id: params[:id]).first
    @category_id         = @item.category_id
    @category_parent     = Category.find(@category_id).parent.parent
    @category_child      = Category.find(@category_id).parent
    @category_grandchild = Category.find(@category_id)
  end

  def find_item(category)
    category.each do |id|
      item_array = Item.includes(:images).where(category_id: id)
      # find_by()メソッドで該当のレコードがなかった場合、itemオブジェクトに空の配列を入れないようにするための処理
      if item_array.present?
        item_array.each do |item|
          if item.present?
            # find_by()メソッドで該当のレコードが見つかった場合、@item配列オブジェクトにそのレコードを追加する
            @items.push(item)
          end
        end
      end
    end
  end

  def index_category_set
    array = [1, 2, 3, 4]
    for num in array do
      search_anc = Category.where('ancestry LIKE(?)', "#{num}/%")
      ids        = []
      search_anc.each do |i|
        ids << i[:id]
      end
      @items = Item.where(category_id: ids).order("id DESC").limit(10)
      instance_variable_set("@cat_no#{num}", @items)
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_card
    @card = CreditCard.where(user_id: current_user.id).first if CreditCard.where(user_id: current_user.id).present?
  end
end

