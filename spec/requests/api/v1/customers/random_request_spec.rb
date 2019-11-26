require 'rails_helper'

RSpec.describe 'Customers API - random endpoint' do

  it 'shows a random customer' do
    customers = create_list(:customer, 3)
    get '/api/v1/customers/random'

    expect(response).to be_successful

    customer = JSON.parse(response.body)

    expect(customer['data']['id'].to_i)
      .to eq(customers[0].id)
      .or eq(customers[1].id)
      .or eq(customers[2].id)
  end

end
