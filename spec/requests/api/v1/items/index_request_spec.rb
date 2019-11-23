require 'rails_helper'

RSpec.describe 'Items API - index endpoint' do

  it 'shows a list of all items' do
    items = create_list(:item, 4)
    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items['data'].length).to eq(4)
  end

end
