require 'rails_helper'

RSpec.describe 'Merchants API' do

  it 'index of records' do
    create_list(:merchant, 4)
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants['data'].length).to eq(4)
  end

  it 'show page by merchant id' do
    id = create(:merchant).id
    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant['data']['id'].to_i).to eq(id)
  end

  it 'sees an error if merchant id does not exist' do
    get '/api/v1/merchants/1'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title']).to eq('Merchant with given ID does not exist.')
  end
end
