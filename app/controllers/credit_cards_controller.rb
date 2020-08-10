class CreditCardsController < ApplicationController
  require 'payjp' #PAYJPとやり取りするために、payjpをロード
  before_action :set_card

  # GET /credit_cards
  # GET /credit_cards.json
  def index
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

  # GET /credit_cards/new
  def new
    # cardがすでに登録済みの場合、indexのページに戻します。
    @card = CreditCard.where(user_id: current_user.id).first
    redirect_to action: 'index' if @card.present?
  end

  # POST /credit_cards
  # POST /credit_cards.json
  def create
    # PAY.JPの秘密鍵をセット（環境変数）
    Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']

    # jsで作成したpayjpTokenがちゃんと入っているか？
    if params['payjpToken'].blank?
      # トークンが空なら戻す
      render 'new' # TODO フラッシュメッセージ
    else
      # 無事トークン作成された場合のアクション。PAY.JPに登録されるユーザーを作成します。
      customer = Payjp::Customer.create(
        description: 'test',
        email:       current_user.email,
        card:        params['payjpToken'],
        metadata:    { user_id: current_user.id } #最悪なくてもOK！
      )

      # PAY.JPのユーザーが作成できたので、Credit_cardモデルを登録します。
      @card = CreditCard.new(user_id: current_user.id, payjp_id: customer.id)
      # 無事、トークン作成とともにcredit_cardsテーブルに登録された場合、indexビューが表示されるように条件分岐
      if @card.save
        redirect_to action: 'index', notice: '支払い情報の登録が完了しました'
      else
        render 'new'
      end
    end
  end

  # DELETE /credit_cards/1
  # DELETE /credit_cards/1.json
  def destroy
    if @card.blank?
      # 未登録なら新規登録画面に
      redirect_to action: 'new'
    else
      # 今回はクレジットカードを削除するだけでなく、PAY.JPの顧客情報も削除する。これによりcreateメソッドが複雑にならない。
      # PAY.JPの秘密鍵をセットして、PAY.JPから情報をする。
      Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
      # PAY.JPの顧客情報を取得
      customer = Payjp::Customer.retrieve(@card.payjp_id)
      customer.delete # PAY.JPの顧客情報を削除
      if @card.destroy # App上でもクレジットカードを削除
        redirect_to action: 'index', notice: '削除しました'
      else
        redirect_to action: 'index', alert: '削除できませんでした'
      end
    end
  end

  def buy
    # 購入する商品を引っ張ってきます。
    @item = Item.find(params[:id])
    # すでに購入されていないか？
    if @item.buyer.present?
      redirect_back(fallback_location: root_path)
    elsif @card.blank?
      # カード情報がなければ、買えないから戻す
      redirect_to action: 'new'
      flash[:alert] = '購入にはクレジットカード登録が必要です'
    else
      # 同時に2人が同時に購入し、二重で購入処理がされることを防ぐための記述
      @item.with_lock do
        # 購入者もいないし、クレジットカードもあるし、決済処理に移行
        Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
        # 請求を発行
        Payjp::Charge.create(
          amount:   @item.price,
          customer: @card.user_id,
          currency: 'jpy'
        )
        # 売り切れなので、itemの情報をアップデートして売り切れにします。
        if @item.update(buyer_id: current_user.id)
          flash[:notice] = '購入しました。'
          redirect_to controller: 'items', action: 'index', id: @item.id
        else
          flash[:alert] = '購入に失敗しました。'
          redirect_to controller: 'items', action: 'index', id: @item.id
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_card
    @card = CreditCard.where(user_id: current_user.id).first if CreditCard.where(user_id: current_user.id).present?
  end

end
