require 'rails_helper'

RSpec.describe 'Invoices API - find all endpoint' do

  before :each do
    create_list(:invoice, 4)

    @customer = create(:customer)
    @merchant = create(:merchant)
    create_list(:invoice, 2,
      customer: @customer,
      merchant: @merchant,
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 18:53:59 UTC'
    )
    @invoice = Invoice.last
  end

  it 'can find invoices by id' do
    get "/api/v1/invoices/find_all?id=#{@invoice.id}"

    expect(response).to be_successful

    invoices = JSON.parse(response.body)

    expect(invoices['data'].length).to eq(1)
    expect(invoices['data'][0]['id'].to_i).to eq(@invoice.id)
  end

  it 'can find invoices by status' do
    get '/api/v1/invoices/find_all?status=shipped'

    expect(response).to be_successful

    invoices = JSON.parse(response.body)

    expect(invoices['data'].length).to eq(6)
    expect(invoices['data'][5]['id'].to_i).to eq(@invoice.id)
  end

  it 'can find invoices by foreign key or timestamp' do
    attributes = {
      'merchant_id' => @merchant.id,
      'customer_id' => @customer.id,
      'created_at'  => @invoice.created_at,
      'updated_at'  => @invoice.updated_at,
    }

    attributes.each do |attribute, value|
      get "/api/v1/invoices/find_all?#{attribute}=#{value}"

      expect(response).to be_successful

      invoices = JSON.parse(response.body)

      expect(invoices['data'].length).to eq(2)
      expect(invoices['data'][1]['id'].to_i).to eq(@invoice.id)
    end
  end

  it 'shows an error if no invoice is found' do
    Invoice.destroy_all
    get '/api/v1/invoices/find_all?id=1'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Invoices with given attributes do not exist.')
  end

end
