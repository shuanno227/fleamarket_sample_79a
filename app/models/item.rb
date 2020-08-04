class Item < ApplicationRecord

  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  belongs_to :category
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  belongs_to :buyer, class_name: 'User', optional: true, foreign_key: 'buyer_id'

  with_options presence: true do |admin|
    admin.validates :name
    admin.validates :price
    admin.validates :description
    admin.validates :condition_id
    admin.validates :shipping_cost_id
    admin.validates :shipping_time_id
    admin.validates :prefecture_id
    admin.validates :seller_id
  end

  validates :name, length: { maximum: 40 }
  validates :description, length: { maximum: 1000 }
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9999999 }


  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :condition
  belongs_to_active_hash :shipping_cost
  belongs_to_active_hash :shipping_time
  belongs_to_active_hash :prefecture
  # delegate :name, to: :prefecture
end
