class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  with_options dependent: :destroy do |d|
    d.has_one :address
    d.has_one :credit_card
    d.has_many :seller_items, foreign_key: 'seller_id', class_name: 'Item'
    d.has_many :buyer_items, foreign_key: 'buyer_id', class_name: 'Item'
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_KATAKANA_REGEX = /\A[\p{katakana}\p{blank}ー－]+\z/.freeze
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-zA-Z])(?=.*?\d)[a-zA-Z\d!@#\$%\^\&*\)\(+=._-]{7,128}\z/i.freeze

  validates :nickname, presence: true, uniqueness: { case_sensitive: true }
  validates :email, presence: true, uniqueness: { case_sensitive: true }, format: { with: VALID_EMAIL_REGEX, message: 'のフォーマットが不適切です' }
  validates :password, presence: true, length: { in: 7..128 }, format: { with: VALID_PASSWORD_REGEX, message: 'は英字と数字両方を含むパスワードを設定してください' }
  validates :last_name, presence: true, length: { maximum: 35 }
  validates :first_name, presence: true, length: { maximum: 35 }
  validates :last_name_hurigana, presence: true, length: { maximum: 35 }, format: { with: VALID_KATAKANA_REGEX, message: 'はカタカナで入力して下さい' }
  validates :first_name_hurigana, presence: true, length: { maximum: 35 }, format: { with: VALID_KATAKANA_REGEX, message: 'はカタカナで入力して下さい' }
  validates :birth_year, presence: true
  validates :birth_month, presence: true
  validates :birth_day, presence: true

end
