require 'rails_helper'

RSpec.describe 'Invoices API - random endpoint' do

  it 'shows a random invoice' do
    invoices = create_list(:invoice, 3)
    get '/api/v1/invoices/random'

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice['data']['id'].to_i)
      .to eq(invoices[0].id).or eq(invoices[1].id).or eq(invoices[2].id)
  end

end
