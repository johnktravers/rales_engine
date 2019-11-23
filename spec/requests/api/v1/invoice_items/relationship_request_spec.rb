require 'rails_helper'

RSpec.describe 'Invoice Items API - relationship endpoints' do

  before :each do
    @belongs_to = ['item', 'invoice']
  end

  it 'shows all resources that an invoice item belongs to' do
    item = create(:item)
    invoice = create(:invoice)
    invoice_item = create(:invoice_item, item: item, invoice: invoice)

    resources = [item, invoice]

    @belongs_to.each_with_index do |resource, i|
      get "/api/v1/invoice_items/#{invoice_item.id}/#{resource}"

      expect(response).to be_successful

      json_resource = JSON.parse(response.body)

      expect(json_resource['data']['id'].to_i).to eq(resources[i].id)
    end
  end

  it 'shows an error if the invoice item does not exist' do
    @belongs_to.each do |resource|
      get "/api/v1/invoice_items/1/#{resource}"

      expect(response).to be_successful

      error = JSON.parse(response.body)

      expect(error['errors'][0]['title'])
        .to eq('Invoice item with given ID does not exist.')
    end
  end

end
