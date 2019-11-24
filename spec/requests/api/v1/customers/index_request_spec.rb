require 'rails_helper'

RSpec.describe 'Customers API - index endpoint' do

  it 'shows a list of all customers' do
    create_list(:customer, 4)
    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)

    expect(customers['data'].length).to eq(4)
  end

end
