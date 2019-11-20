require 'rails_helper'

RSpec.describe 'Merchants API - index endpoint' do

  it 'retrieves a list of merchants' do
    create_list(:merchant, 4)
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants['data'].length).to eq(4)
  end

end
