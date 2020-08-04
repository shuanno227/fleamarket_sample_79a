class ItemsController < ApplicationController
  def index
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

# Image.where(item_id: @item).ids idを配列に格納
# @image


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


  private

  def item_params
    params.require(:item).permit(:name, :price, :description, :condition_id, :shipping_cost_id, :shipping_time_id, :prefecture_id, :category_id, :brand, :buyer_id, :seller_id, images_attributes: [:image, :id]).merge(seller_id: current_user.id, category_id: params[:category_id])
  end

end

