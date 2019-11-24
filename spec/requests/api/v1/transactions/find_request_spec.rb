require 'rails_helper'

RSpec.describe 'Transactions API - find endpoint' do

  it 'can find a transaction by any attribute' do
    create_list(:transaction, 4)
    transaction = create(:transaction,
      result: 1,
      credit_card_number: '4927382940671023',
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 18:53:59 UTC'
    )

    attributes = {
      'id'                 => transaction.id,
      'invoice_id'         => transaction.invoice_id,
      'result'             => transaction.result,
      'credit_card_number' => transaction.credit_card_number,
    }

    attributes.each do |attribute, value|
      get "/api/v1/transactions/find?#{attribute}=#{value}"

      expect(response).to be_successful

      json_transaction = JSON.parse(response.body)

      expect(json_transaction['data']['id'].to_i).to eq(transaction.id)
    end
  end

  it 'shows an error if no transaction is found' do
    get '/api/v1/transactions/find?result=success'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Transaction with given attributes does not exist.')
  end

end
