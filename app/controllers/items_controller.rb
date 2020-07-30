class ItemsController < ApplicationController
  def index
    @items = Item.includes([:images]).order(created_at: :desc)
  end

  def show
  end
end
