require 'rails_helper'

RSpec.describe 'Customers API - relationship endpoints' do

  before :each do
    @customer = create(:customer)
    @has_many = ['invoices', 'transactions']
  end

  it 'shows all resources belonging to a customer' do
    invoices = create_list(:invoice, 4, customer: @customer)
    transactions = create_list(:transaction, 4, invoice: invoices[0])
    create_list(:invoice, 2)
    create_list(:transaction, 2)

    resources = [invoices, transactions]

    @has_many.each_with_index do |resource, i|
      get "/api/v1/customers/#{@customer.id}/#{resource}"

      expect(response).to be_successful

      json_resources = JSON.parse(response.body)

      expect(json_resources['data'].length).to eq(4)
      expect(json_resources['data'][3]['id'].to_i).to eq(resources[i].last.id)
    end
  end

  it 'shows an error if the customer does not have that resource' do
    @has_many.each do |resource|
      get "/api/v1/customers/#{@customer.id}/#{resource}"

      expect(response).to be_successful

      error = JSON.parse(response.body)

      expect(error['errors'][0]['title'])
        .to eq("Customer with given ID has no #{resource}.")
    end
  end

  it 'shows an error if the customer does not exist' do
    Customer.destroy_all

    @has_many.each do |resource|
      get "/api/v1/customers/1/#{resource}"

      expect(response).to be_successful

      error = JSON.parse(response.body)

      expect(error['errors'][0]['title'])
        .to eq('Customer with given ID does not exist.')
    end
  end

end
