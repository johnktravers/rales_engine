FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::TvShows::GameOfThrones.quote }
    unit_price { Faker::Number.decimal(l_digits: 2) }
    merchant
  end
end
