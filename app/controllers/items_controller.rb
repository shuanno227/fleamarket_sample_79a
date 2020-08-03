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
  end

  def show
    @item = Item.find(params[:id])
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

