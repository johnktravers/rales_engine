require 'rails_helper'

RSpec.describe Customer, type: :model do

  describe 'validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many(:merchants).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
  end

  describe 'class methods' do
    it 'random customer' do
      customers = create_list(:customer, 3)

      expect(Customer.random)
        .to eq(customers[0]).or eq(customers[1]).or eq(customers[2])
    end

    it 'customers with pending invoices' do
      merchant = create(:merchant)
      customers = create_list(:customer, 3)

      customers.each_with_index do |customer, i|
        create(:invoice, merchant: merchant, customer: customers[i])
      end

      create(:transaction, result: 0, invoice: Invoice.first)
      create(:transaction, result: 1, invoice: Invoice.second)

      expect(Customer.customers_with_pending_invoices(merchant.id))
        .to eq([customers[1], customers[2]])
    end
  end

  describe 'instance methods' do
    it 'favorite merchant' do
      customer = create(:customer)
      merchants = create_list(:merchant, 3)

      merchants.each do |merchant|
        create_list(:invoice, 5, customer: customer, merchant: merchant)
      end

      Invoice.all.each_with_index do |invoice, i|
        create(:transaction, invoice: invoice, result: (i.odd? ? 0 : 1))
      end

      expect(customer.favorite_merchant).to eq(merchants[1])
    end
  end

end
