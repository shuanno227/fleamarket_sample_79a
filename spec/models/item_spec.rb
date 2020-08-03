require 'rails_helper'

describe Item do
  describe '#create' do

    # 必須項目を全て満たす場合
    it "全ての必須項目が入力されていれば出品できる" do
      item = create(:item)
      expect(item).to be_valid
    end

    # 必須項目が空の場合のテスト
    it "is invalid without a name" do
      item = build(:item, name: "")
      item.valid?
      expect(item.errors[:name]).to include("を入力してください")
    end

    it "is invalid without a price" do
      item = build(:item, price: "")
      item.valid?
      expect(item.errors[:price]).to include("を入力してください")
    end

    it "is invalid without a description" do
      item = build(:item, description: "")
      item.valid?
      expect(item.errors[:description]).to include("を入力してください")
    end

    it "is invalid without a condition_id" do
      item = build(:item, condition_id: "")
      item.valid?
      expect(item.errors[:condition_id]).to include("を入力してください")
    end

    it "is invalid without a shipping_cost_id" do
      item = build(:item, shipping_cost_id: "")
      item.valid?
      expect(item.errors[:shipping_cost_id]).to include("を入力してください")
    end

    it "is invalid without a shipping_time_id" do
      item = build(:item, shipping_time_id: "")
      item.valid?
      expect(item.errors[:shipping_time_id]).to include("を入力してください")
    end

    it "is invalid without a prefecture_id" do
      item = build(:item, prefecture_id: "")
      item.valid?
      expect(item.errors[:prefecture_id]).to include("を入力してください")
    end

    #商品名が40文字以上の場合
    it "is invalid with a name that has more than 40 characters" do
      item = build(:item, name: "a" * 41)
      item.valid?
      expect(item.errors[:name]).to include("は40文字以内で入力してください")
    end

    #descriptionの文字が1000文字以上の場合
    it "is invalid with a description that has more than 1000 characters" do
      item = build(:item, description: "a" * 1001)
      item.valid?
      expect(item.errors[:description]).to include("は1000文字以内で入力してください")
    end

    #priceが9999999円以上の場合
    it "is invalid price is more than 9999999" do
      item = build(:item, price: 10000000)
      item.valid?
      expect(item.errors[:price]).to include("は9999999以下の値にしてください")
    end

    it "is invalid price is less than 300" do
      item = build(:item, price: 299)
      item.valid?
      expect(item.errors[:price]).to include("は300以上の値にしてください")
    end
  end
end