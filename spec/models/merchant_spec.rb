require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
  end

  describe 'class methods' do
    before :each do
      @merchants = create_list(:merchant, 3)
      customers = create_list(:customer, 3)

      @merchants.each_with_index do |merchant, i|
        create(:item, merchant: merchant)
        create_list(:invoice, 5, merchant: merchant, customer: customers[i])
      end

      items = Item.all

      Invoice.all.each_with_index do |invoice, i|
        create(:invoice_item, invoice: invoice, unit_price: ((i + 1) * 10 % 43), item: items[i % 3], quantity: i)
        create(:transaction, invoice: invoice, result: (i.even? ? 0 : 1))
      end
    end

    it 'random merchant' do
      expect(Merchant.random)
        .to eq(@merchants[0]).or eq(@merchants[1]).or eq(@merchants[2])
    end

    it 'top merchants by revenue' do
      expect(Merchant.top_merchants_by_revenue(2))
        .to eq([@merchants[2], @merchants[1]])
      expect(Merchant.top_merchants_by_revenue(3))
        .to eq([@merchants[2], @merchants[1], @merchants[0]])
    end

    it 'top merchants by items sold' do
      expect(Merchant.top_merchants_by_items_sold(2))
        .to eq([@merchants[2], @merchants[1]])
      expect(Merchant.top_merchants_by_items_sold(3))
        .to eq([@merchants[2], @merchants[1], @merchants[0]])
    end
  end

  describe 'instance methods' do
    before :each do
      @merchant = create(:merchant)
      @item = create(:item, merchant: @merchant)
      @customers = create_list(:customer, 2)

      create_list(:invoice, 2, merchant: @merchant, customer: @customers[0], created_at: '2012-03-04 15:54:10 UTC')
      create_list(:invoice, 3, merchant: @merchant, customer: @customers[1], created_at: '2012-03-05 15:54:10 UTC')

      Invoice.all.each_with_index do |invoice, i|
        create(:invoice_item, invoice: invoice, unit_price: (i + 1) * 10 % 43, item: @item)
        create(:transaction, invoice: invoice, result: (i.even? ? 0 : 1))
      end
    end

    it 'favorite customer' do
      expect(@merchant.favorite_customer).to eq(@customers[1])
    end

    it 'total revenue' do
      expect(@merchant.total_revenue).to eq(47.0)
    end

    it 'total revenue on date' do
      expect(@merchant.total_revenue_on_date('2012-03-04')).to eq(10.0)
      expect(@merchant.total_revenue_on_date('2012-03-05')).to eq(37.0)
    end
  end

end
