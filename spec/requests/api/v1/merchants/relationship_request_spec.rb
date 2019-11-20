require 'rails_helper'

RSpec.describe 'Merchant API - relationship endpoints' do

  describe 'has many items' do
    before :each do
      @merchant = create(:merchant)
    end

    it 'shows all items belonging to a merchant' do
      items = create_list(:item, 4, merchant: @merchant)
      other_merchant = create(:merchant)
      create_list(:item, 2, merchant: other_merchant)

      get "/api/v1/merchants/#{@merchant.id}/items"

      expect(response).to be_successful

      json_items = JSON.parse(response.body)

      expect(json_items['data'].length).to eq(4)
      expect(json_items['data'][3]['id'].to_i).to eq(items.last.id)
    end

    it 'shows an error if the merchant has no items' do
      get "/api/v1/merchants/#{@merchant.id}/items"

      expect(response).to be_successful

      error = JSON.parse(response.body)

      expect(error['errors'][0]['title'])
        .to eq('Merchant with given ID has no items.')
    end

    it 'shows an error if the merchant does not exist' do
      get '/api/v1/merchants/2316413/items'

      expect(response).to be_successful

      error = JSON.parse(response.body)

      expect(error['errors'][0]['title'])
        .to eq('Merchant with given ID does not exist.')
    end
  end

  describe 'has many invoices' do
    before :each do
      @merchant = create(:merchant)
    end

    it 'shows all invoices belonging to a merchant' do
      customer = create(:customer)
      invoices = create_list(:invoice, 4, merchant: @merchant, customer: customer)
      other_merchant = create(:merchant)
      create_list(:invoice, 2, merchant: other_merchant, customer: customer)

      get "/api/v1/merchants/#{@merchant.id}/invoices"

      expect(response).to be_successful

      json_invoices = JSON.parse(response.body)

      expect(json_invoices['data'].length).to eq(4)
      expect(json_invoices['data'][3]['id'].to_i).to eq(invoices.last.id)
    end

    it 'shows an error if the merchant has no invoices' do
      get "/api/v1/merchants/#{@merchant.id}/invoices"

      expect(response).to be_successful

      error = JSON.parse(response.body)

      expect(error['errors'][0]['title'])
        .to eq('Merchant with given ID has no invoices.')
    end

    it 'shows an error if the merchant does not exist' do
      get '/api/v1/merchants/2316413/invoices'

      expect(response).to be_successful

      error = JSON.parse(response.body)

      expect(error['errors'][0]['title'])
        .to eq('Merchant with given ID does not exist.')
    end
  end

end
