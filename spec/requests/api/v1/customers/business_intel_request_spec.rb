require 'rails_helper'

RSpec.describe 'Customers API - business intelligence endpoints' do

  it 'shows the favorite merchant for a given customer' do
    customer = create(:customer)
    merchants = create_list(:merchant, 3)

    merchants.each do |merchant|
      create_list(:invoice, 5, customer: customer, merchant: merchant)
    end

    Invoice.all.each_with_index do |invoice, i|
      create(:transaction, invoice: invoice, result: (i.odd? ? 0 : 1))
    end

    get "/api/v1/customers/#{customer.id}/favorite_merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant['data']['id'].to_i).to eq(merchants[1].id)
  end

  it 'shows an error if the customer does not exist' do
    get "/api/v1/customers/1/favorite_merchant"

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Customer with given ID does not exist.')
  end

end
