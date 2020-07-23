# fleamarket_sample_79a DB 設計

## users テーブル

| Column                    | Type   | Options     |
| ------------------------- | ------ | ----------- |
| nickname                  | string | null: false |
| email                     | string | null: false |
| password                  | string | null: false |
| user_name                 | string | null: false |
| hurigana                  | string | null: false |
| birth_date                | string | null: false |
| destination_name          | string | null: false |
| destination_name_hurigana | string | null: false |
| post_code                 | string | null: false |
| prefecture                | string | null: false |
| city                      | string | null: false |
| address                   | string | null: false |
| room_number               | string | null: false |
| telephone_number          | string | null: false |

### Association

- has_many :purchases
- has_many :items

---

## items テーブル

| Column        | Type   | Options                        |
| ------------- | ------ | ------------------------------ |
| name          | string | null: false                    |
| price         | string | null: false                    |
| description   | string | null: false                    |
| stock         | string | null: false                    |
| condition     | string | null: false                    |
| size          | string | null: false                    |
| shipping_cost | string | null: false                    |
| shipping_time | string | null: false                    |
| sending_area  | string | null: false                    |
| prefecture_id | string | null: false, foreign_key: true |
| brand_id      | string | foreign_key: true              |
| user_id       | string | null: false, foreign_key: true |

### Association

- belongs_to :prefecture
- belongs_to :brand
- has_one :purchase
- has_many :images
- has_many :items_categories
- has_many :categories, through: :items_categories

---

## categories テーブル

| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

### Association

- has_many :items_categories
- has_many :items, through: :items_categories

---

## items_categories テーブル

| Column       | Type   | Options                        |
| ------------ | ------ | ------------------------------ |
| item_id      | string | null: false, foreign_key: true |
| categorie_id | string | null: false, foreign_key: true |

### Association

- belongs_to :item
- belongs_to :category

---

## images テーブル

| Column  | Type   | Options                        |
| ------- | ------ | ------------------------------ |
| image   | string | null: false                    |
| item_id | string | null: false, foreign_key: true |

### Association

- belongs_to :items

---

## prefectures テーブル

| Column     | Type   | Options     |
| ---------- | ------ | ----------- |
| prefecture | string | null: false |

### Association

- has_many :items

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
| item_id | string | null: false, foreign_key: true |
| user_id | string | null: false, foreign_key: true |

### Association

- belongs_to :item
- belongs_to :user

---
