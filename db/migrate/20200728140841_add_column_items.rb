class AddColumnItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :name , :string, :null=>false
    add_column :items, :price , :integer, :null=>false
    add_column :items, :description, :text, :null=>false
    add_column :items, :stock , :string, :null=>false
    add_column :items, :condition_id , :integer, :null=>false
    add_column :items, :shipping_cost_id , :integer, :null=>false
    add_column :items, :shipping_time_id , :integer, :null=>false
    add_column :items, :prefecture_id , :integer, :null=>false
    add_reference :items, :category, foreign_key: true, :null=>false
    add_reference :items, :brand, foreign_key: true
    add_reference :items, :buyer, foregin_key: {to_table: :users}
    add_reference :items, :seller, foregin_key: {to_table: :users}, :null=>false
  end
end