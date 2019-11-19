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
      customer = Customer.create!(first_name: 'Chad', last_name: 'Belfort')
      merchant = Merchant.create!(name: 'Once and Floral')
      invoice = customer.invoices.create!(merchant_id: merchant.id, status: 0)

      expect(invoice.status).to eq('shipped')
      expect(invoice.shipped?).to eq(true)
    end
  end

end
