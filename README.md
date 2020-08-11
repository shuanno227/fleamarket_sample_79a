# fleamarket_sample_79a DB 設計

## users テーブル

| Column                | Type   | Options     |
| --------------------- | ------ | ----------- |
| nickname              | string | null: false |
| email                 | string | null: false |
| password              | string | null: false |
| password_confirmation | string | null: false |
| first_name            | string | null: false |
| last_name             | string | null: false |
| first_name_hurigana   | string | null: false |
| last_name_furigana    | string | null: false |
| birth_year            | string | null: false |
| birth_month           | string | null: false |
| birth_day             | string | null: false |

### Association

- has_one :address, dependent: :destroy
- has_one :credit_card, dependent: :destroy
- has_many :seller_items, foreign_key: "seller_id", class_name: "Item"
- has_many :buyer_items, foreign_key: "buyer_id", class_name: "Item"

---

## addresses テーブル

| Column                     | Type       | Options                        |
| -------------------------- | ---------- | ------------------------------ |
| destination_name           | string     | null: false                    |
| destination_name_hurigana  | string     | null: false                    |
| post_code                  | string     | null: false                    |
| prefecture_id(acitve_hash) | integer    | null: false                    |
| city                       | string     | null: false                    |
| address                    | string     | null: false                    |
| room_number                | string     |                                |
| telephone_number           | string     |                                |
| user                       | references | null: false, foreign_key: true |

### Association

- belongs_to_active_hash :prefecture
- belongs_to :user

---

## items テーブル

| Column                        | Type       | Options                        |
| ----------------------------- | ---------- | ------------------------------ |
| name                          | string     | null: false                    |
| price                         | integer    | null: false                    |
| description                   | text       | null: false                    |
| condition_id(acitve_hash)     | integer    | null: false                    |
| shipping_cost_id(acitve_hash) | integer    | null: false                    |
| shipping_time_id(acitve_hash) | integer    | null: false                    |
| prefecture_id(acitve_hash)    | integer    | null: false                    |
| category                      | references | null: false, foreign_key: true |
| brand                         | references | foreign_key: true              |
| seller                        | references | null: false, foreign_key: true |
| buyer                         | references | foreign_key: true              |

### Association

- has_many :images, dependent: :destroy
- belongs_to_active_hash :condition
- belongs_to_active_hash :shipping_cost
- belongs_to_active_hash :shipping_time
- belongs_to_active_hash :prefecture
- belongs_to :category
- belongs_to :brand
- belongs_to :seller, class_name: "User"
- belongs_to :buyer, class_name: "User"

---

## categories テーブル

| Column   | Type   | Options     |
| -------- | ------ | ----------- |
| name     | string | null: false |
| ancestry | string |             |

### Association

- has_many :items
- has_ancestry

---

## images テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| image  | string     | null: false                    |
| item   | references | null: false, foreign_key: true |

### Association

- belongs_to :items

---

## brands テーブル

| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

### Association

- has_many :items

---

## credit_cards テーブル

| Column   | Type       | Options                        |
| -------- | ---------- | ------------------------------ |
| payjp_id | string     | null: false                    |
| user     | references | null: false, foreign_key: true |

### Association

- belongs_to :user

---
