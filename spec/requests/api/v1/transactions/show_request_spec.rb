require 'rails_helper'

RSpec.describe 'Transactions API - show endpoint' do

  it 'can get one transaction by its id' do
    id = create(:transaction).id
    get "/api/v1/transactions/#{id}"

    expect(response).to be_successful

    transaction = JSON.parse(response.body)

    expect(transaction['data']['id'].to_i).to eq(id)
  end

  it 'shows an error if transaction does not exist' do
    get '/api/v1/transactions/1'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Transaction with given ID does not exist.')
  end

end
