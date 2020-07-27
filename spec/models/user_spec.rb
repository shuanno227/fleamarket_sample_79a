require 'rails_helper'
describe User do
  describe '#create' do
    
    # 文字が入っているかどうかのテスト

    it "is invalid without a nickname" do
      user = build(:user, nickname: "")
      user.valid?
      expect(user.errors[:nickname]).to include("を入力してください")
    end


    it "is invalid without a email" do
      user = build(:user, email: "")
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    it "is invalid without a password" do
      user = build(:user, password: "")
      user.valid?
      expect(user.errors[:password]).to include("を入力してください")
    end


    it "is invalid without a password_confirmation" do
      user = build(:user, password_confirmation: "")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end

    it "is invalid without a last_name" do
      user = build(:user, last_name: "")
      user.valid?
      expect(user.errors[:last_name]).to include("を入力してください")
    end


    it "is invalid without a first_name" do
      user = build(:user, first_name: "")
      user.valid?
      expect(user.errors[:first_name]).to include("を入力してください")
    end

    it "is invalid without a last_name_hurigana" do
      user = build(:user, last_name_hurigana: "")
      user.valid?
      expect(user.errors[:last_name_hurigana]).to include("を入力してください")
    end

    it "is invalid without a first_name_hurigana" do
      user = build(:user, first_name_hurigana: "")
      user.valid?
      expect(user.errors[:first_name_hurigana]).to include("を入力してください")
    end

    it "is invalid without a birth_year" do
      user = build(:user, birth_year: "")
      user.valid?
      expect(user.errors[:birth_year]).to include("を入力してください")
    end

    it "is invalid without a birth_month" do
      user = build(:user, birth_month: "")
      user.valid?
      expect(user.errors[:birth_month]).to include("を入力してください")
    end

    it "is invalid without a birth_day" do
      user = build(:user, birth_day: "")
      user.valid?
      expect(user.errors[:birth_day]).to include("を入力してください")
    end

# emailのフォーマットが不適切でないか

    it 'is invalid with a email wrong format' do
      user = build(:user, email: '12345678')
      user.valid?
      expect(user.errors[:email]).to include("のフォーマットが不適切です")
    end

    it 'is invalid with a email wrong format' do
      user = build(:user, email: 'a1234567')
      user.valid?
      expect(user.errors[:email]).to include("のフォーマットが不適切です")
    end

# パスワードが7〜128文字であるか

    it "is invalid with a password that has less than 6 characters " do
      user = build(:user, password: "a2345", password_confirmation: "a2345")
      user.valid?
      expect(user.errors[:password]).to include("は7文字以上で入力してください")
    end

    it "is valid with a password that has more than 7 characters " do
      user = build(:user, password: "a234567", password_confirmation: "a234567")
      user.valid?
      expect(user).to be_valid
    end

    it "is valid with a password that has more than 128 characters " do
      user = build(:user, password: "aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa123",
      password_confirmation: "aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa123") # 128文字
      user.valid?
      expect(user).to be_valid
    end

    it "is invalid with a password that has more than 129 characters " do
      user = build(:user, password: "aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa1234",
      password_confirmation: "aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa12345aaaaa1234") # 129文字
      user.valid?
      expect(user.errors[:password][0]).to include("は128文字以内で入力してください")
    end

# パスワードに英字と数字が含まれているか

    it "is valid with a password that Contains letters and numbers " do
      user = build(:user, password: "a234567", password_confirmation: "a234567")
      user.valid?
      expect(user).to be_valid
    end

    it "is invalid with a password except for numbers" do
      user = build(:user, password: "1111111111", password_confirmation: "1111111111")
      user.valid?
      expect(user.errors[:password][0]).to include("")
    end

    it "is invalid with a password except for alphabets" do
      user = build(:user, password: "aaaaaaa", password_confirmation: "aaaaaaa")
      user.valid?
      expect(user.errors[:password][0]).to include("")
    end

# パスワードに記号を入れても登録できる

    it "is valid with a password that Contains letters and numbers and symbol " do
      user = build(:user, password: "a123456!@#$%^&*)(=_-", password_confirmation: "a123456!@#$%^&*)(=_-")
      user.valid?
      expect(user).to be_valid
    end

# パスワードとパスワード（確認）が一致しているか

    it "is valid with a password and password confirmation match " do
      user = build(:user, password: "a123456", password_confirmation: "a123456")
      user.valid?
      expect(user).to be_valid
    end

    it "is valid with a password and password confirmation match " do
      user = build(:user, password: "a123456", password_confirmation: "b987654")
      user.valid?
      expect(user.errors[:password_confirmation][0]).to include("とパスワードの入力が一致しません")
    end

# 氏名が35文字以下で入力されているか カナ入力になっているか

    it "is valid with a last_name that has less than 35 characters " do
      user = build(:user, last_name: "12345671234567123456712345671234567") # 35文字
      user.valid?
      expect(user).to be_valid
    end

    it "is invalid with a last_name that has more than 36 characters " do
      user = build(:user, last_name: "123456712345671234567123456712345671") # 36文字
      user.valid?
      expect(user.errors[:last_name]).to include("は35文字以内で入力してください")
    end

    it "is valid with a first_name that has less than 35 characters " do
      user = build(:user, first_name: "12345671234567123456712345671234567")
      user.valid?
      expect(user).to be_valid
    end

    it "is invalid with a first_name that has more than 36 characters " do
      user = build(:user, first_name: "123456712345671234567123456712345671")
      user.valid?
      expect(user.errors[:first_name]).to include("は35文字以内で入力してください")
    end

    it "is valid with a last_name_hurigana that has less than 35 characters " do
      user = build(:user, last_name_hurigana: "アアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアア") # 35文字
      user.valid?
      expect(user).to be_valid
    end

    it "is invalid with a last_name_hurigana that has more than 36 characters " do
      user = build(:user, last_name_hurigana: "アアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアア") # 36文字
      user.valid?
      expect(user.errors[:last_name_hurigana]).to include("は35文字以内で入力してください")
    end

    it "is valid with a first_name_hurigana that has less than 35 characters " do
      user = build(:user, first_name_hurigana: "アアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアア")
      user.valid?
      expect(user).to be_valid
    end

    it "is invalid with a first_name_hurigana that has more than 36 characters " do
      user = build(:user, first_name_hurigana: "アアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアアア")
      user.valid?
      expect(user.errors[:first_name_hurigana]).to include("は35文字以内で入力してください")
    end

    it "is valid with a last_name_hurigana that katakana " do
      user = build(:user, last_name_hurigana: "ア")
      user.valid?
      expect(user).to be_valid
    end

    it "is invalid with a last_name_hurigana that katakana " do
      user = build(:user, last_name_hurigana: "あ")
      user.valid?
      expect(user.errors[:last_name_hurigana][0]).to include("はカタカナで入力して下さい")
    end

    it "is valid with a first_name_hurigana that katakana " do
      user = build(:user, first_name_hurigana: "ア")
      user.valid?
      expect(user).to be_valid
    end

    it "is invalid with a first_name_hurigana that katakana " do
      user = build(:user, first_name_hurigana: "あ")
      user.valid?
      expect(user.errors[:first_name_hurigana][0]).to include("はカタカナで入力して下さい")
    end

  end
end

describe Address do
  describe '#create' do
    # 文字が入っているかどうかのテスト

    it "is invalid without a destination_name" do
      address = build(:address, destination_name: "")
      address.valid?
      expect(address.errors[:destination_name]).to include("を入力してください")
    end

    it "is invalid without a destination_name_hurigana" do
      address = build(:address, destination_name_hurigana: "")
      address.valid?
      expect(address.errors[:destination_name_hurigana]).to include("を入力してください")
    end

    it "is invalid without a post_code" do
      address = build(:address, post_code: "")
      address.valid?
      expect(address.errors[:post_code]).to include("を入力してください")
    end

    it "is invalid without a prefecture_id" do
      address = build(:address, prefecture_id: "")
      address.valid?
      expect(address.errors[:prefecture_id]).to include("を入力してください")
    end

    it "is invalid without a city" do
      address = build(:address, city: "")
      address.valid?
      expect(address.errors[:city]).to include("を入力してください")
    end

    it "is invalid without a address" do
      address = build(:address, address: "")
      address.valid?
      expect(address.errors[:address]).to include("を入力してください")
    end

    # カタ入力になっているか
    it "is valid with a destination_name_hurigana that katakana " do
      address = build(:address, destination_name_hurigana: "ア")
      address.valid?
      expect(address).to be_valid
    end

    it "is invalid with a destination_name_hurigana that katakana " do
      address = build(:address, destination_name_hurigana: "あ")
      address.valid?
      expect(address.errors[:destination_name_hurigana][0]).to include("はカタカナで入力して下さい")
    end

    # 電話番号の形式が不適切でないか
    it "is valid with a telephone_number that Phone number format " do
      address = build(:address, telephone_number: "08012345678")
      address.valid?
      expect(address).to be_valid
    end

    it "is invalid with a telephone_number that Phone number format " do
      address = build(:address, telephone_number: "a8012345678")
      address.valid?
      expect(address.errors[:telephone_number][0]).to include("フォーマットが不適切です")
    end

    # 郵便番号が不適切な形式になっていないか

    it "is valid with a post_code that Postal code format " do
      address = build(:address, post_code: "000-0000")
      address.valid?
      expect(address).to be_valid
    end

    it "is invalid with a post_code that Postal code format " do
      address = build(:address, post_code: "a00-0000")
      address.valid?
      expect(address.errors[:post_code]).to include("フォーマットが不適切です")
    end

  end
end