class CreateCreditCards < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_cards do |t|
      t.string :payjp_id, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
