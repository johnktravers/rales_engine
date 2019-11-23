require 'rails_helper'

RSpec.describe 'Invoice Items API - find all endpoint' do

  before :each do
    create_list(:invoice_item, 4)
    @invoice = create(:invoice)
    @item = create(:item)

    create_list(:invoice_item, 2,
      quantity: 7,
      unit_price: 43.02,
      invoice: @invoice,
      item: @item,
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 18:53:59 UTC'
    )
    @invoice_item = InvoiceItem.last
  end

  it 'can find invoice items by id' do
    get "/api/v1/invoice_items/find_all?id=#{@invoice_item.id}"

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)

    expect(invoice_items['data'].length).to eq(1)
    expect(invoice_items['data'][0]['id'].to_i).to eq(@invoice_item.id)
  end

  it 'can find an invoice items by any attribute' do
    attributes = {
      'quantity'   => @invoice_item.quantity,
      'unit_price' => @invoice_item.unit_price,
      'item_id'    => @invoice_item.item_id,
      'invoice_id' => @invoice_item.invoice_id,
      'created_at' => @invoice_item.created_at,
      'updated_at' => @invoice_item.updated_at
    }

    attributes.each do |attribute, value|
      get "/api/v1/invoice_items/find_all?#{attribute}=#{value}"

      expect(response).to be_successful

      json_invoice_item = JSON.parse(response.body)

      expect(json_invoice_item['data'].length).to eq(2)
      expect(json_invoice_item['data'][1]['id'].to_i).to eq(@invoice_item.id)
    end
  end

  it 'shows an error if no invoice item is found' do
    get '/api/v1/invoice_items/find_all?quantity=12.93'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Invoice items with given attributes do not exist.')
  end

end
