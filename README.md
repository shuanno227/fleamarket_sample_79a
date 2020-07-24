# fleamarket_sample_79a DB 設計

## users テーブル

| Column              | Type   | Options     |
| ------------------- | ------ | ----------- |
| nickname            | string | null: false |
| email               | string | null: false |
| password            | string | null: false |
| first_name          | string | null: false |
| last_name           | string | null: false |
| first_name_hurigana | string | null: false |
| last_name_furigana  | string | null: false |
| birth_year          | string | null: false |
| birth_month         | string | null: false |
| birth_day           | string | null: false |

### Association

- has_one :address
- has_many :purchases
- has_many :items

---

## addresses テーブル

| Column                     | Type    | Options                        |
| -------------------------- | ------- | ------------------------------ |
| destination_name           | string  | null: false                    |
| destination_name_hurigana  | string  | null: false                    |
| post_code                  | string  | null: false                    |
| prefecture_id(acitve_hash) | integer | null: false                    |
| city                       | string  | null: false                    |
| address                    | string  | null: false                    |
| room_number                | string  |                                |
| telephone_number           | string  |                                |
| user_id                    | bigint  | null: false, foreign_key: true |

### Association

- belongs_to :user

---

## items テーブル

| Column                        | Type    | Options                        |
| ----------------------------- | ------- | ------------------------------ |
| name                          | string  | null: false                    |
| price                         | integer | null: false                    |
| description                   | text    | null: false                    |
| stock                         | string  | null: false                    |
| condition_id(acitve_hash)     | integer | null: false, foreign_key: true |
| shipping_cost_id(acitve_hash) | integer | null: false, foreign_key: true |
| shipping_time_id(acitve_hash) | integer | null: false, foreign_key: true |
| prefecture_id(acitve_hash)    | integer | null: false, foreign_key: true |
| category_id                   | integer | null: false, foreign_key: true |
| brand_id                      | integer | foreign_key: true              |
| user_id                       | bigint  | null: false, foreign_key: true |

### Association

- has_one :purchase
- has_many :images
- belongs_to :category
- belongs_to :brand
- belongs_to :user

---

## categories テーブル

| Column   | Type    | Options     |
| -------- | ------- | ----------- |
| name     | string  | null: false |
| ancestry | integer | null: false |

### Association

- has_many :items
- has_ancestry

---

## images テーブル

| Column  | Type   | Options                        |
| ------- | ------ | ------------------------------ |
| image   | string | null: false                    |
| item_id | bigint | null: false, foreign_key: true |

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

## purchases テーブル

| Column  | Type   | Options                        |
| ------- | ------ | ------------------------------ |
| item_id | bigint | null: false, foreign_key: true |
| user_id | bigint | null: false, foreign_key: true |

### Association

- belongs_to :item
- belongs_to :user

---
