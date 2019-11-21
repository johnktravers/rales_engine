require 'rails_helper'

RSpec.describe 'Merchants API - relationship endpoints' do

  before :each do
    @merchant = create(:merchant)
    @has_many = ['items', 'invoices']
  end

  it 'shows all resources belonging to a merchant' do
    items = create_list(:item, 4, merchant: @merchant)
    invoices = create_list(:invoice, 4, merchant: @merchant)
    create_list(:item, 2)
    create_list(:invoice, 2)

    resources = [items, invoices]

    @has_many.each_with_index do |resource, i|
      get "/api/v1/merchants/#{@merchant.id}/#{resource}"

      expect(response).to be_successful

      json_resources = JSON.parse(response.body)

      expect(json_resources['data'].length).to eq(4)
      expect(json_resources['data'][3]['id'].to_i).to eq(resources[i].last.id)
    end
  end

  it 'shows an error if the merchant does not have that resource' do
    @has_many.each do |resource|
      get "/api/v1/merchants/#{@merchant.id}/#{resource}"

      expect(response).to be_successful

      error = JSON.parse(response.body)

      expect(error['errors'][0]['title'])
        .to eq("Merchant with given ID has no #{resource}.")
    end
  end

  it 'shows an error if the merchant does not exist' do
    @has_many.each do |resource|
      get "/api/v1/merchants/2316413/#{resource}"

      expect(response).to be_successful

      error = JSON.parse(response.body)

      expect(error['errors'][0]['title'])
        .to eq('Merchant with given ID does not exist.')
    end
  end

end
