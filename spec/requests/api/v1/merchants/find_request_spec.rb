require 'rails_helper'

RSpec.describe 'Merchants API - find endpoint' do

  it 'can find a merchant by any attribute' do
    create_list(:merchant, 4)
    merchant = create(:merchant,
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 18:53:59 UTC'
    )

    attributes = {
      'id'         => merchant.id,
      'name'       => merchant.name,
      'created_at' => merchant.created_at,
      'updated_at' => merchant.updated_at
    }

    attributes.each do |attribute, value|
      get "/api/v1/merchants/find?#{attribute}=#{value}"

      expect(response).to be_successful

      json_merchant = JSON.parse(response.body)

      expect(json_merchant['data']['id'].to_i).to eq(merchant.id)
    end
  end

  it 'cannot find a merchant that does not exist' do
    get "/api/v1/merchants/find?name=bob"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant['errors'][0]['title'])
      .to eq('Merchant with given attributes does not exist.')
  end

end
