require 'rails_helper'

RSpec.describe 'Invoice Items API - show endpoint' do

  it 'can get one invoice item by its id' do
    id = create(:invoice_item).id
    get "/api/v1/invoice_items/#{id}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice['data']['id'].to_i).to eq(id)
  end

  it 'shows an error if invoice item does not exist' do
    get '/api/v1/invoice_items/1'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Invoice item with given ID does not exist.')
  end

end
