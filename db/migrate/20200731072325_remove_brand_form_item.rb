class RemoveBrandFormItem < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :items, :brands
    remove_reference :items, :brand
  end
end
