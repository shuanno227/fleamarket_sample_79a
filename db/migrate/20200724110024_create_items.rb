class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.text :description, null: false
      t.string :stock, null: false
      t.references :condition, null: false, foreign_key: true
      t.references :shipping_cost, null: false, foreign_key: true
      t.references :shipping_time, null: false, foreign_key: true
      t.references :prefecture, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :brand, foreign_key: true
      t.references :seller, null: false, foreign_key: true
      t.references :buyer, foreign_key: true
      t.timestamps
    end
  end
end
