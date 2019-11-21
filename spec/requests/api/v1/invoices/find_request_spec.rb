require 'rails_helper'

RSpec.describe 'Invoices API - find endpoint' do

  before :each do
    create_list(:invoice, 4)
    @invoice = create(:invoice,
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 18:53:59 UTC'
    )
  end

  it 'can find an invoice by id' do
    get "/api/v1/invoices/find?id=#{@invoice.id}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice['data']['id'].to_i).to eq(@invoice.id)
  end

  it 'can find an invoice by status' do
    get '/api/v1/invoices/find?status=shipped'

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice['data']['id'].to_i).to eq(Invoice.first.id)
  end

  it 'can find an invoice by merchant id' do
    get "/api/v1/invoices/find?merchant_id=#{@invoice.merchant_id}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice['data']['id'].to_i).to eq(@invoice.id)
  end

  it 'can find an invoice by customer id' do
    get "/api/v1/invoices/find?customer_id=#{@invoice.customer_id}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice['data']['id'].to_i).to eq(@invoice.id)
  end

  it 'can find an invoice by created at timestamp' do
    get "/api/v1/invoices/find?created_at=#{@invoice.created_at}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice['data']['id'].to_i).to eq(@invoice.id)
  end

  it 'can find an invoice by updated at timestamp' do
    get "/api/v1/invoices/find?updated_at=#{@invoice.updated_at}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice['data']['id'].to_i).to eq(@invoice.id)
  end

  it 'shows an error if no invoice is found' do
    Invoice.destroy_all
    get '/api/v1/invoices/find?id=1'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Invoice with given attributes does not exist.')
  end

end
