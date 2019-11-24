require 'rails_helper'

RSpec.describe 'Transactions API - find all endpoint' do

  before :each do
    create_list(:transaction, 4)
    @invoice = create(:invoice)

    create_list(:transaction, 2,
      invoice: @invoice,
      result: 1,
      credit_card_number: '4302959367185950',
      created_at: '2012-03-27 15:53:59 UTC',
      updated_at: '2012-03-27 19:53:59 UTC'
    )
    @transaction = Transaction.last
  end

  it 'can find transactions by id' do
    get "/api/v1/transactions/find_all?id=#{@transaction.id}"

    expect(response).to be_successful

    transactions = JSON.parse(response.body)

    expect(transactions['data'].length).to eq(1)
    expect(transactions['data'][0]['id'].to_i).to eq(@transaction.id)
  end

  it 'can find transactions by any attribute' do
    attributes = {
      'invoice_id'         => @transaction.invoice_id,
      'result'             => @transaction.result,
      'credit_card_number' => @transaction.credit_card_number,
      'created_at'         => @transaction.created_at,
      'updated_at'         => @transaction.updated_at,
    }

    attributes.each do |attribute, value|
      get "/api/v1/transactions/find_all?#{attribute}=#{value}"

      expect(response).to be_successful

      transactions = JSON.parse(response.body)

      expect(transactions['data'].length).to eq(2)
      expect(transactions['data'][1]['id'].to_i).to eq(@transaction.id)
    end
  end

  it 'shows an error if no transaction is found' do
    Transaction.destroy_all
    get '/api/v1/transactions/find_all?result=success'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Transactions with given attributes do not exist.')
  end

end
