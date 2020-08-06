FactoryBot.define do

  factory :user do

    nickname { 'abe' }
    email { '494a98sc8d@yahoo.co.jp' }
    password { 'a111111' }
    password_confirmation { 'a111111' }
    last_name { '田中' }
    first_name { '太郎' }
    last_name_hurigana { 'タナカ' }
    first_name_hurigana { 'タロウ' }
    birth_year { 1 }
    birth_month { 1 }
    birth_day { 1 }

  end

  factory :address do

    destination_name { '山田太郎' }
    destination_name_hurigana { 'ヤマダタロウ' }
    post_code { '111-1111' }
    prefecture_id { 1 }
    city { '福岡' }
    address { '中央区' }
    telephone_number { '08012345678' }

  end

end
