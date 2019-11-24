require 'rails_helper'

RSpec.describe 'Transactions API - random endpoint' do

  it 'can show a random transaction' do
    transactions = create_list(:transaction, 3)
    get '/api/v1/transactions/random'

    expect(response).to be_successful

    json_transaction = JSON.parse(response.body)

    expect(json_transaction['data']['id'].to_i)
      .to eq(transactions[0].id)
      .or eq(transactions[1].id)
      .or eq(transactions[2].id)
  end

end
