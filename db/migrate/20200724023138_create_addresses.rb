class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :destination_name, null: false
      t.string :destination_name_hurigana, null: false
      t.string :post_code, null: false
      t.integer :prefecture_id, null: false     # TODO references型に修正
      t.string :city, null: false
      t.string :address, null: false
      t.string :room_number
      t.string :telephone_number
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
