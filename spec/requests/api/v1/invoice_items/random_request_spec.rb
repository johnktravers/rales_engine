require 'rails_helper'

RSpec.describe 'Invoice Items API - random endpoint' do

  it 'show a random invoice item' do
    invoice_items = create_list(:invoice_item, 3)
    get '/api/v1/invoice_items/random'

    expect(response).to be_successful

    invoice_item = JSON.parse(response.body)

    expect(invoice_item['data']['id'].to_i)
      .to eq(invoice_items[0].id)
      .or eq(invoice_items[1].id)
      .or eq(invoice_items[2].id)
  end

end
