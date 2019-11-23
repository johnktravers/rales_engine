require 'rails_helper'

RSpec.describe 'Items API - find all endpoint' do

  before :each do
    create_list(:item, 4)
    @merchant = create(:merchant)

    @item = create_list(:item, 2,
      name: 'Hefty Rain Coat',
      description: 'This will definitely protect you from the elements.',
      unit_price: 133.24,
      merchant: @merchant,
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 18:53:59 UTC'
    )
    @item = Item.last
  end

  it 'can find items by id' do
    get "/api/v1/items/find_all?id=#{@item.id}"

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items['data'].length).to eq(1)
    expect(items['data'][0]['id'].to_i).to eq(@item.id)
  end

  it 'can find items by any attribute' do
    attributes = {
      'name'        => @item.name,
      'description' => @item.description,
      'unit_price'  => @item.unit_price,
      'merchant_id' => @item.merchant_id,
      'created_at'  => @item.created_at,
      'updated_at'  => @item.updated_at
    }

    attributes.each do |attribute, value|
      get "/api/v1/items/find_all?#{attribute}=#{value}"

      expect(response).to be_successful

      json_items = JSON.parse(response.body)

      expect(json_items['data'].length).to eq(2)
      expect(json_items['data'][1]['id'].to_i).to eq(@item.id)
    end
  end

  it 'shows an error if no item is found' do
    get '/api/v1/items/find_all?unit_price=124.87'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Items with given attributes do not exist.')
  end

end
