require 'rails_helper'

RSpec.describe 'Customers API - find all endpoint' do

  before :each do
    create_list(:customer, 4)
    create_list(:customer, 2,
      first_name: 'Twilliam',
      last_name: 'Prasadi',
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 18:53:59 UTC'
    )
    @customer = Customer.last
  end

  it 'can find customers by id' do
    get "/api/v1/customers/find_all?id=#{@customer.id}"

    expect(response).to be_successful

    json_customer = JSON.parse(response.body)

    expect(json_customer['data'].length).to eq(1)
    expect(json_customer['data'][0]['id'].to_i).to eq(@customer.id)
  end

  it 'can find customers by any attribute' do
    attributes = {
      'first_name' => @customer.first_name,
      'last_name'  => @customer.last_name,
      'created_at' => @customer.created_at,
      'updated_at' => @customer.updated_at
    }

    attributes.each do |attribute, value|
      get "/api/v1/customers/find_all?#{attribute}=#{value}"

      expect(response).to be_successful

      customers = JSON.parse(response.body)

      expect(customers['data'].length).to eq(2)
      expect(customers['data'][1]['id'].to_i).to eq(@customer.id)
    end
  end

  it 'shows an error if no customer is found' do
    get '/api/v1/customers/find_all?first_name=sdgasfh'

    expect(response).to be_successful

    error = JSON.parse(response.body)

    expect(error['errors'][0]['title'])
      .to eq('Customers with given attributes do not exist.')
  end

end
