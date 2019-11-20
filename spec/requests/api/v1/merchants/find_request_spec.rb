require 'rails_helper'

RSpec.describe 'Merchants API - find endpoint' do

  before :each do
    create_list(:merchant, 4)
    @merchant = create(:merchant,
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 18:53:59 UTC'
    )
  end

  it 'can find a merchant by id' do
    get "/api/v1/merchants/find?id=#{@merchant.id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant['data']['id'].to_i).to eq(@merchant.id)
  end

  it 'can find a merchant by name' do
    get "/api/v1/merchants/find?name=#{@merchant.name}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant['data']['attributes']['name']).to eq(@merchant.name)
  end

  it 'can find a merchant by created at timestamp' do
    get "/api/v1/merchants/find?created_at=#{@merchant.created_at}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant['data']['id'].to_i).to eq(@merchant.id)
  end

  it 'can find a merchant by updated at timestamp' do
    get "/api/v1/merchants/find?updated_at=#{@merchant.updated_at}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant['data']['id'].to_i).to eq(@merchant.id)
  end

  it 'cannot find a merchant that does not exist' do
    get "/api/v1/merchants/find?name=sldkghjafhngl"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant['errors'][0]['title'])
      .to eq('Merchant with given attributes does not exist.')
  end

end
