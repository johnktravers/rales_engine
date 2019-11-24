require 'rails_helper'

RSpec.describe 'Customers API - find endpoint' do

  it 'can find a customer by any attribute' do
    create_list(:customer, 4)
    customer = create(:customer,
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 18:53:59 UTC'
    )

    attributes = {
      'id'         => customer.id,
      'first_name' => customer.first_name,
      'last_name'  => customer.last_name,
      'created_at' => customer.created_at,
      'updated_at' => customer.updated_at,
    }

    attributes.each do |attribute, value|
      get "/api/v1/customers/find?#{attribute}=#{value}"

      expect(response).to be_successful

      json_customer = JSON.parse(response.body)

      expect(json_customer['data']['id'].to_i).to eq(customer.id)
    end
  end

  it 'shows an error if no customer is found' do
    get '/api/v1/customers/find?name=Bob'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Customer with given attributes does not exist.')
  end

end
