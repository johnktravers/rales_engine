require 'rails_helper'

RSpec.describe 'Invoice Items API - index endpoint' do

  it 'retrieves a list of invoice items' do
    create_list(:invoice_item, 4)
    get '/api/v1/invoice_items'

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)

    expect(invoice_items['data'].length).to eq(4)
  end

end
