require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
  end

  describe 'class methods' do
    before :each do
      @merchants = create_list(:merchant, 3)
    end

    it 'random merchant' do
      expect(Merchant.random_merchant)
        .to eq(@merchants[0]).or eq(@merchants[1]).or eq(@merchants[2])
    end

    it 'top merchants by revenue' do
      customers = create_list(:customer, 3)
      @merchants.each_with_index do |merchant, i|
        create_list(:invoice, 5, merchant: merchant, customer: customers[i])
      end
      Invoice.all.each_with_index do |invoice, i|
        create(:invoice_item, invoice: invoice, unit_price: ((i + 1) * 10 % 43))
        create(:transaction, invoice: invoice)
      end

      expect(Merchant.top_merchants_by_revenue(2))
        .to eq([@merchants[0], @merchants[1]])
    end
  end

  describe 'instance methods' do
    it 'favorite customer' do
      merchant = create(:merchant)
      customers = create_list(:customer, 2)
      create_list(:invoice, 2, merchant: merchant, customer: customers[0])
      create_list(:invoice, 3, merchant: merchant, customer: customers[1])

      Invoice.all.each_with_index do |invoice, i|
        create(:invoice_item, invoice: invoice, unit_price: (i + 1) * 10 % 43)
        create(:transaction, invoice: invoice, result: (i.even? ? 0 : 1))
      end

      expect(merchant.favorite_customer).to eq(customers[1])
    end
  end

end
