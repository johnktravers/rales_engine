require 'rails_helper'

RSpec.describe 'Merchants API - random endpoint' do

  it 'can show a random merchant' do
    merchants = create_list(:merchant, 3)
    get '/api/v1/merchants/random'

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant['data']['id'].to_i)
      .to eq(merchants[0].id).or eq(merchants[1].id).or eq(merchants[2].id)
  end

end
