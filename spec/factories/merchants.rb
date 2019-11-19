FactoryBot.define do
  factory :merchant do
    name { Faker::Space.company }
  end
end
