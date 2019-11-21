require 'rails_helper'

RSpec.describe 'Merchants API - invoices relationship endpoint' do

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
