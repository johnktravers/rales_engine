require 'rails_helper'

RSpec.describe 'Invoices API - relationship endpoints' do

  before :each do
    @invoice = create(:invoice)
    @has_many = ['transactions', 'invoice_items', 'items']
    @belongs_to = ['merchant', 'customer']
  end

  it 'shows all resources belonging to an invoice' do
    transactions = create_list(:transaction, 4, invoice: @invoice)
    items = create_list(:item, 4)
    items.each { |item| create(:invoice_item, invoice: @invoice, item: item) }
    invoice_items = InvoiceItem.limit(4)

    create_list(:transaction, 2)
    create_list(:item, 2)
    create_list(:invoice_item, 2)

    resources = [transactions, invoice_items, items]

    @has_many.each_with_index do |resource, i|
      get "/api/v1/invoices/#{@invoice.id}/#{resource}"

      expect(response).to be_successful

      json_resources = JSON.parse(response.body)

      expect(json_resources['data'].length).to eq(4)
      expect(json_resources['data'][3]['id'].to_i).to eq(resources[i].last.id)
    end
  end

  it 'shows all resources that an invoice belongs to' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, merchant: merchant, customer: customer)

    resources = [merchant, customer]

    @belongs_to.each_with_index do |resource, i|
      get "/api/v1/invoices/#{invoice.id}/#{resource}"

      expect(response).to be_successful

      json_resources = JSON.parse(response.body)

      expect(json_resources['data']['id'].to_i).to eq(resources[i].id)
    end
  end

  it 'shows an error if the invoice does not have that resource' do
    @has_many.each do |resource|
      get "/api/v1/invoices/#{@invoice.id}/#{resource}"

      expect(response).to be_successful

      error = JSON.parse(response.body)

      expect(error['errors'][0]['title'])
        .to eq("Invoice with given ID has no #{resource}.")
    end
  end

  it 'shows an error if the invoice does not exist' do
    (@has_many + @belongs_to).each do |resource|
      get "/api/v1/invoices/23513/#{resource}"

      expect(response).to be_successful

      error = JSON.parse(response.body)

      expect(error['errors'][0]['title'])
        .to eq('Invoice with given ID does not exist.')
    end
  end

end
