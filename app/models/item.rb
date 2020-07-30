class Item < ApplicationRecord

  has_many :images, dependent: :destroy
  belongs_to :category
  belongs_to :brand
  belongs_to :seller, class_name: "User"
  belongs_to :buyer, class_name: "User"

  with_options presence: true do |admin|
    admin.validates :name
    admin.validates :price
    admin.validates :description
    admin.validates :stock
    admin.validates :condition_id
    admin.validates :shipping_cost_id
    admin.validates :shipping_time_id
    admin.validates :prefecture_id
    admin.validates :seller_id
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :condition
  belongs_to_active_hash :shipping_cost
  belongs_to_active_hash :shipping_time
  belongs_to_active_hash :prefecture
  delegate :name, to: :prefecture

  enum status: { sell: 0, buy: 1 , trading:2}
  scope :on_sell, -> { where(status: 0) }
end
