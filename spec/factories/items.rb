FactoryBot.define do

  factory :item do
    name                    { 'パンダくん' }
    description             { 'パンダくんのぬいぐるみです' }
    condition_id            { '1' }
    shipping_cost_id        { '1' }
    shipping_time_id        { '1' }
    prefecture_id           { '1' }
    price                   { '1000' }
    association :seller, factory: :user
    association :category, factory: :category

  end
end
