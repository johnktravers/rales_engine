require 'rails_helper'

RSpec.describe 'Items API - random endpoint' do

  it 'can show a random item' do
    item = create_list(:item, 3)
    get '/api/v1/items/random'

    expect(response).to be_successful

    json_item = JSON.parse(response.body)

    expect(json_item['data']['id'].to_i)
      .to eq(item[0].id).or eq(item[1].id).or eq(item[2].id)
  end

end
