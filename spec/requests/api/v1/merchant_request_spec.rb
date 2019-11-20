require 'rails_helper'

RSpec.describe 'Merchants API' do

  it 'index of records endpoint' do
    create_list(:merchant, 4)
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants['data'].length).to eq(4)
  end

  describe 'show endpoint' do
    it 'can get one merchant by its id' do
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

      expect(error['errors'][0]['title'])
        .to eq('Merchant with given ID does not exist.')
    end
  end

  describe 'find by parameters endpoint' do
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

end
