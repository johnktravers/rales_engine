require 'rails_helper'

RSpec.describe 'Items API - show endpoint' do

  it 'can get one item by its id' do
    id = create(:item).id
    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    item = JSON.parse(response.body)

    expect(item['data']['id'].to_i).to eq(id)
  end

  it 'show an error if item does not exist' do
    get '/api/v1/items/1'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Item with given ID does not exist.')
  end

end
