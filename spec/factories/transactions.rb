FactoryBot.define do
  factory :transaction do
    credit_card_number { '4017503416578382' }
    result { 0 }
    invoice
  end
end
