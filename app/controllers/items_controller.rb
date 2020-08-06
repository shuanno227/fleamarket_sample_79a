class ItemsController < ApplicationController

before_action :set_item, only: [:show, :edit, :update, :destroy]
before_action :show_all_instance, only: [:show, :edit,:update, :destroy]


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

  def update
    if item_params[:images_attributes].nil?
      flash.now[:alert] = '更新できませんでした 【画像を１枚以上入れてください】'
      render :edit
    else
      exit_ids = []
      item_params[:images_attributes].each do |a,b|
        exit_ids << item_params[:images_attributes].dig(:"#{a}",:id).to_i
      end
      ids = Image.where(item_id: params[:id]).map{|image| image.id }
      delete__db = ids - exit_ids
      Image.where(id:delete__db).destroy_all
      @item.touch
      if @item.update(item_params)
        redirect_to  item_path
      else
        flash.now[:alert] = '更新できませんでした'
        render :edit
      end
    end
  end



  def show
    @image = Image.where(item_id: params[:id])
    @item_grandchildId = Category.find(@item.category_id)
    @item_childId = @item_grandchildId.parent
    @item_parentId =  Category.find(@item_childId.ancestry)
    @condition = Condition.find(@item.condition_id)
    @shipping_cost = ShippingCost.find(@item.shipping_cost_id)
    @shipping_time = ShippingTime.find(@item.shipping_time_id)
    @prefecture =  Prefecture.find(@item.prefecture_id)
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
    params.require(:item).permit(:image_ids, :name, :price, :description, :condition_id, :shipping_cost_id, :shipping_time_id, :prefecture_id, :category_id, :brand, :buyer_id, :seller_id, images_attributes: [:image,:_destroy, :id]).merge(seller_id: current_user.id, category_id: params[:category_id])
  end

  
  def set_item
    @item = Item.find(params[:id])
  end

  

  def show_all_instance
    @user = User.find(@item.seller_id)
    @images = Image.where(item_id: params[:id])
    @images_first = Image.where(item_id: params[:id]).first
    @category_id = @item.category_id
    @category_parent = Category.find(@category_id).parent.parent
    @category_child = Category.find(@category_id).parent
    @category_grandchild = Category.find(@category_id)
  end

end

