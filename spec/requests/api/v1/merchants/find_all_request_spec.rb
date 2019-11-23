require 'rails_helper'

RSpec.describe 'Merchants API - find all endpoint' do

  before :each do
    create_list(:merchant, 4)
    create_list(:merchant, 2,
      name: 'Once and Floral',
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 18:53:59 UTC'
    )
    @merchant = Merchant.last
  end

  it 'can find merchants by id' do
    get "/api/v1/merchants/find_all?id=#{@merchant.id}"

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants['data'].length).to eq(1)
    expect(merchants['data'][0]['id'].to_i).to eq(@merchant.id)
  end

  it 'can find merchants by name or timestamp' do
    attributes = {
      'name' => @merchant.name,
      'created_at' => @merchant.created_at,
      'updated_at' => @merchant.updated_at
    }

    attributes.each do |attribute, value|
      get "/api/v1/merchants/find_all?#{attribute}=#{value}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body)

      expect(merchants['data'].length).to eq(2)
      expect(merchants['data'][1]['id'].to_i).to eq(@merchant.id)
    end
  end

  it 'cannot find merchants that do not exist' do
    get "/api/v1/merchants/find_all?name=sldkghjafhngl"

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants['errors'][0]['title'])
      .to eq('Merchants with given attributes do not exist.')
  end

end
