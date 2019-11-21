require 'rails_helper'

RSpec.describe Invoice, type: :model do

  describe 'validations' do
    it { should validate_presence_of :status }
  end

  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many :transactions }
  end

  describe 'status' do
    it 'can be created as a shipped invoice' do
      invoice = create(:invoice)

      expect(invoice.status).to eq('shipped')
      expect(invoice.shipped?).to eq(true)
    end
  end

  describe 'class methods' do
    it 'total revenue on date' do
      create_list(:invoice, 5, created_at: '2012-03-24 15:54:10 UTC')
      create_list(:invoice, 2)
      Invoice.all.each_with_index do |invoice, i|
        create(:invoice_item, invoice: invoice, unit_price: (i + 1) * 10 % 43)
        create(:transaction, invoice: invoice, result: (i.even? ? 0 : 1))
      end

      expect(Invoice.total_revenue_on_date('2012-03-24')).to eq(47.0)
    end
  end

end
