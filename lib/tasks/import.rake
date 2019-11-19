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

  task customers: :environment do
    CSV.foreach('db/data/customers.csv', headers: true) do |row|
      Customer.create!(row.to_h)
    end
  end

  task invoices: :environment do
    CSV.foreach('db/data/invoices.csv', headers: true) do |row|
      row['status'] = 0 if row['status'] == 'shipped'
      Invoice.create!(row.to_h)
    end
  end

  task invoice_items: :environment do
    CSV.foreach('db/data/invoice_items.csv', headers: true) do |row|
      row['unit_price'] = row['unit_price'].to_f / 100
      InvoiceItem.create!(row.to_h)
    end
  end

  task transactions: :environment do
    CSV.foreach('db/data/transactions.csv', headers: true) do |row|
      row.delete('credit_card_expiration_date')
      row['result'] = 0 if row['result'] == 'success'
      row['result'] = 1 if row['result'] == 'failed'
      Transaction.create!(row.to_h)
    end
  end

end
