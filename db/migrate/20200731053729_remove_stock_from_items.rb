class RemoveStockFromItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :items, :stock, :string
  end
end
