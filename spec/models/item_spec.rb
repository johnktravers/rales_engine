require 'rails_helper'

RSpec.describe Item, type: :model do

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'class methods' do
    before :each do
      @items = create_list(:item, 3)
      @invoices = create_list(:invoice, 15)

      @invoices.each_with_index do |invoice, i|
        create(:invoice_item, invoice: invoice, unit_price: (i + 1) * 10 % 43, item: @items[i % 3], quantity: i)
        create(:transaction, invoice: invoice, result: (i.even? ? 0 : 1))
      end
    end

    it 'random item' do
      expect(Item.random)
        .to eq(@items[0]).or eq(@items[1]).or eq(@items[2])
    end

    it 'top items by revenue' do
      expect(Item.top_items_by_revenue(2)).to eq([@items[2], @items[1]])
      expect(Item.top_items_by_revenue(3))
        .to eq([@items[2], @items[1], @items[0]])
    end

    it 'top items by quantity sold' do
      expect(Item.top_items_by_quantity_sold(2)).to eq([@items[2], @items[0]])
      expect(Item.top_items_by_quantity_sold(3))
        .to eq([@items[2], @items[0], @items[1]])

    end
  end

end
