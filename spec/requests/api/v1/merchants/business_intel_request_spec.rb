require 'rails_helper'

RSpec.describe 'Merchants API - business intelligence endpoints' do

  describe 'successful endpoint data retrieval' do
    before :each do
      @merchants = create_list(:merchant, 3)
      @customers = create_list(:customer, 4)
      @merchants.each_with_index do |merchant, i|
        create_list(:invoice, 2, merchant: merchant, customer: @customers[i], created_at: "2012-03-#{i}4 15:54:10 UTC")
        create_list(:invoice, 3, merchant: merchant, customer: @customers[i + 1], created_at: "2012-03-#{i}4 15:54:10 UTC")
      end

      Invoice.all.each_with_index do |invoice, i|
        create(:invoice_item, invoice: invoice, unit_price: (i + 1) * 10 % 43)
        create(:transaction, invoice: invoice, result: (i.even? ? 0 : 1))
      end
    end

    it 'shows the top merchants by revenue' do
      get '/api/v1/merchants/most_revenue?quantity=2'

      expect(response).to be_successful

      merchants = JSON.parse(response.body)

      expect(merchants['data'][0]['id'].to_i).to eq(@merchants[0].id)
      expect(merchants['data'][1]['id'].to_i).to eq(@merchants[1].id)
    end

    it 'shows the total revenue for a given date' do
      get '/api/v1/merchants/revenue?date=2012-03-24'

      expect(response).to be_successful

      revenue = JSON.parse(response.body)

      expect(revenue['data']['attributes']['total_revenue']).to eq('46.00')
    end

    it 'shows the favorite customer for a given merchant' do
      get "/api/v1/merchants/#{@merchants[0].id}/favorite_customer"

      expect(response).to be_successful

      customer = JSON.parse(response.body)

      expect(customer['data']['id'].to_i).to eq(@customers[1].id)
    end
  end

  describe 'customers with pending invoices' do
    it 'shows customers with pending invoices for a given merchant' do
      merchant = create(:merchant)
      customers = create_list(:customer, 3)

      customers.each_with_index do |customer, i|
        create(:invoice, merchant: merchant, customer: customers[i])
      end

      create(:transaction, result: 0, invoice: Invoice.first)
      create(:transaction, result: 1, invoice: Invoice.second)

      get "/api/v1/merchants/#{merchant.id}/customers_with_pending_invoices"

      expect(response).to be_successful

      json_customers = JSON.parse(response.body)

      expect(json_customers['data'].length).to eq(2)
      expect(json_customers['data'][0]['id'].to_i).to eq(customers[1].id)
      expect(json_customers['data'][1]['id'].to_i).to eq(customers[2].id)
    end
  end

  describe 'endpoint error handling' do
    it 'shows an error if quantity is not a valid integer' do
      get '/api/v1/merchants/most_revenue?quantity=-4'

      expect(response).to be_successful

      merchants = JSON.parse(response.body)

      expect(merchants['errors'][0]['title'])
        .to eq('Please input an integer quantity that is greater than 0.')
    end

    it 'shows an error if date is not valid' do
      get '/api/v1/merchants/revenue?date=2012-15-24'

      expect(response).to be_successful

      revenue = JSON.parse(response.body)

      expect(revenue['errors'][0]['title'])
        .to eq('Incorrect date format. Please use format YYYY-MM-DD.')
    end

    it 'shows the favorite customer for a given merchant' do
      paths = ['favorite_customer', 'customers_with_pending_invoices']

      paths.each do |path|
        get "/api/v1/merchants/1/#{path}"

        expect(response).to be_successful

        customer = JSON.parse(response.body)

        expect(customer['errors'][0]['title'])
          .to eq('Merchant with given ID does not exist.')
      end
    end
  end

end
