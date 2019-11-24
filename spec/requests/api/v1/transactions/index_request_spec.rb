require 'rails_helper'

RSpec.describe 'Transactions API - index endpoint' do

  it 'shows a list of all transactions' do
    create_list(:transaction, 4)
    get '/api/v1/transactions'

    expect(response).to be_successful

    transactions = JSON.parse(response.body)

    expect(transactions['data'].length).to eq(4)
  end

end
