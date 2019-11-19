require 'csv'

namespace :import do

  task merchants: :environment do
    CSV.foreach('db/data/merchants.csv', headers: true) do |row|
      Merchant.create!(row.to_h)
    end
  end

  task items: :environment do
    CSV.foreach('db/data/items.csv', headers: true) do |row|
      row['unit_price'] = row['unit_price'].to_f / 100
      Item.create!(row.to_h)
    end
  end

end
