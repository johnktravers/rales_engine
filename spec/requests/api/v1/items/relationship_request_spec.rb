require 'rails_helper'

RSpec.describe 'Items API - relationship endpoints' do

  before :each do
    @item = create(:item)
  end

  it 'shows all invoice items belonging to an item' do
    invoice_items = create_list(:invoice_item, 4, item: @item)

    get "/api/v1/items/#{@item.id}/invoice_items"

    expect(response).to be_successful

    json_invoice_items = JSON.parse(response.body)

    expect(json_invoice_items['data'].length).to eq(4)
    expect(json_invoice_items['data'][3]['id'].to_i)
      .to eq(invoice_items.last.id)
  end

  it 'shows the merchant an item belongs to' do
    get "/api/v1/items/#{@item.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant['data']['id'].to_i).to eq(@item.merchant_id)
  end

  it 'shows an error if the item has no invoice items' do
    get "/api/v1/items/#{@item.id}/invoice_items"

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Item with given ID has no invoice items.')
  end

  it 'shows an error if the item does not exist' do
    Item.destroy_all
    get '/api/v1/items/1/invoice_items'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Item with given ID does not exist.')
  end

end
