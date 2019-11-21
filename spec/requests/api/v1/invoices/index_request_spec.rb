require 'rails_helper'

RSpec.describe 'Invoices API - index endpoint' do

  it 'retrieves a list of invoices' do
    create_list(:invoice, 4)
    get '/api/v1/invoices'

    expect(response).to be_successful

    invoices = JSON.parse(response.body)

    expect(invoices['data'].length).to eq(4)
  end
end
