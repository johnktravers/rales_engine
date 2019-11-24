require 'rails_helper'

RSpec.describe 'Transactions API - relationship endpoints' do

  it 'shows the invoice a transaction belongs to' do
    transaction = create(:transaction)
    get "/api/v1/transactions/#{transaction.id}/invoice"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice['data']['id'].to_i).to eq(transaction.invoice_id)
  end

  it 'shows an error if the transaction does not exist' do
    get '/api/v1/transactions/1/invoice'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Transaction with given ID does not exist.')
  end

end
