require 'rails_helper'

RSpec.describe 'Invoices API - show endpoint' do

  it 'can get one invoice by its id' do
    id = create(:invoice).id
    get "/api/v1/invoices/#{id}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice['data']['id'].to_i).to eq(id)
  end

  it 'shows an error if invoice does not exist' do
    get '/api/v1/invoices/1'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Invoice with given ID does not exist.')
  end

end
