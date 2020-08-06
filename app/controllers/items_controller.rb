class ItemsController < ApplicationController
  before_action :index_category_set, only: :index

  def index
    @items = Item.includes([:images]).order(created_at: :desc)
    @ladies = Item.includes(:images).where(category_id: 33..211).order("id DESC")
    @mens = Item.includes(:images).where(category_id: 226..356).order("id DESC")
    @babies = Item.includes(:images).where(category_id: 372..490).order("id DESC")
    @interior = Item.includes(:images).where(category_id: 540..633).order("id DESC")
  end

  def new
    if user_signed_in?
      @item = Item.new
      @item.images.new
    else
      redirect_to root_path
    end
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
    @image = Image.where(item_id: @item)
    gon.imageLength = @image.length

  end

  def update
    @item = Item.find(params[:id])
    if item_params[:images_attributes].nil?
      flash.now[:alert] = '更新できませんでした 【画像を１枚以上入れてください】'
      render :edit
    else
      exit_ids = []
      item_params[:images_attributes].each do |a, b|
        exit_ids << item_params[:images_attributes].dig(:"#{a}", :id).to_i
      end
      ids = Image.where(item_id: params[:id]).map { |image| image.id }
      delete__db = ids - exit_ids
      Image.where(id: delete__db).destroy_all
      @item.touch
      if @item.update(item_params)
        redirect_to update_done_items_path
      else
        flash.now[:alert] = '更新できませんでした'
        render :edit
      end
    end
    binding.pry
  end


  def show
    @item = Item.find(params[:id])
    @image = Image.where(item_id: @item)
    @item_grandchildId = Category.find(@item.category_id)
    @item_childId = @item_grandchildId.parent
    @item_parentId = Category.find(@item_childId.ancestry)
    @condition = Condition.find(@item.condition_id)
    @shipping_cost = ShippingCost.find(@item.shipping_cost_id)
    @shipping_time = ShippingTime.find(@item.shipping_time_id)
    @prefecture = Prefecture.find(@item.prefecture_id)
    @price = @item.price
    gon.imageId = @image.ids
  end

  def destroy
    @item = Item.find(params[:id])
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

  private

  def item_params
    params.require(:item).permit(:name, :price, :description, :condition_id, :shipping_cost_id, :shipping_time_id, :prefecture_id, :category_id, :brand, :buyer_id, :seller_id, images_attributes: [:image, :id]).merge(seller_id: current_user.id, category_id: params[:category_id])
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

  private

  def index_category_set
    array = [1, 2, 3, 4]
    for num in array do
      search_anc = Category.where('ancestry LIKE(?)', "#{num}/%")
      ids = []
      search_anc.each do |i|
        ids << i[:id]
      end
      @items = Item.where(category_id: ids).order("id DESC").limit(10)
      instance_variable_set("@cat_no#{num}", @items)
    end
  end

  def item_params
    params.require(:item).permit(:name, :price, :description, :condition_id, :shipping_cost_id, :shipping_time_id, :prefecture_id, :category_id, :brand, :buyer_id, :seller_id, images_attributes: [:image, :id]).merge(seller_id: current_user.id, category_id: params[:category_id])
  end
end

