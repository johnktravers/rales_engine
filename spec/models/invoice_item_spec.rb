require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do

  describe 'validations' do
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }

    it { should validate_numericality_of(:quantity).only_integer }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
  end

  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :invoice }
  end

  describe 'class methods' do
    it 'random invoice item' do
      invoice_items = create_list(:invoice_item, 3)

      expect(InvoiceItem.random)
        .to eq(invoice_items[0])
        .or eq(invoice_items[1])
        .or eq(invoice_items[2])
    end
  end

end
