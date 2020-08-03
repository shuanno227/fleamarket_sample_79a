class CreditCard < ApplicationRecord

  belongs_to :user

  validates :payjp_id, presence: true

end
