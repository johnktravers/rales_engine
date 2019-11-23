require 'rails_helper'

RSpec.describe 'Items API - find endpoint' do

  it 'can find an item by any attribute' do
    create_list(:item, 4)
    item = create(:item,
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 18:53:59 UTC'
    )

    attributes = {
      'id'          => item.id,
      'name'        => item.name,
      'description' => item.description,
      'unit_price'  => item.unit_price,
      'merchant_id' => item.merchant_id,
      'created_at'  => item.created_at,
      'updated_at'  => item.updated_at
    }

    attributes.each do |attribute, value|
      get "/api/v1/items/find?#{attribute}=#{value}"

      expect(response).to be_successful

      json_item = JSON.parse(response.body)

      expect(json_item['data']['id'].to_i).to eq(item.id)
    end
  end

  it 'shows an error if no item is found' do
    get '/api/v1/items/find?unit_price=24.87'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Item with given attributes does not exist.')
  end

end
