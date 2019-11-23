require 'rails_helper'

RSpec.describe 'Invoice Items API - find endpoint' do

  it 'can find an invoice item by any attribute' do
    create_list(:invoice_item, 4)
    invoice_item = create(:invoice_item,
      quantity: 10,
      unit_price: 13.42,
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 18:53:59 UTC'
    )

    attributes = {
      'id'         => invoice_item.id,
      'quantity'   => invoice_item.quantity,
      'unit_price' => invoice_item.unit_price,
      'item_id'    => invoice_item.item_id,
      'invoice_id' => invoice_item.invoice_id,
      'created_at' => invoice_item.created_at,
      'updated_at' => invoice_item.updated_at
    }

    attributes.each do |attribute, value|
      get "/api/v1/invoice_items/find?#{attribute}=#{value}"

      expect(response).to be_successful

      json_invoice_item = JSON.parse(response.body)

      expect(json_invoice_item['data']['id'].to_i).to eq(invoice_item.id)
    end
  end

  it 'shows an error if no invoice item is found' do
    get '/api/v1/invoice_items/find?id=1'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Invoice item with given attributes does not exist.')
  end

end
