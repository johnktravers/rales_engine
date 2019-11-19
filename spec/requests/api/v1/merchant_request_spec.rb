require 'rails_helper'

RSpec.describe 'Merchants API' do

  it 'index of records' do
    create_list(:merchant, 4)
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants['data'].length).to eq(4)
  end

end
