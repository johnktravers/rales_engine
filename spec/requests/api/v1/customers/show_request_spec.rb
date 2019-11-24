require 'rails_helper'

RSpec.describe 'Customers API - show endpoint' do

  it 'can get one customer by its id' do
    id = create(:customer).id
    get "/api/v1/customers/#{id}"

    expect(response).to be_successful

    customer = JSON.parse(response.body)

    expect(customer['data']['id'].to_i).to eq(id)
  end

  it 'shows an error if customer does not exist' do
    get '/api/v1/customers/1'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Customer with given ID does not exist.')
  end

end
