require 'rails_helper'

RSpec.describe Invoice, type: :model do

  describe 'validations' do
    it { should validate_presence_of :status }
  end

  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
  end

  describe 'status' do
    it 'can be created as a shipped invoice' do
      customer = Customer.create!(first_name: 'Chad', last_name: 'Belfort')
      merchant = Merchant.create!(name: 'Once and Floral')
      order_1 = customer.invoices.create!(merchant_id: merchant.id, status: 0)

      expect(order_1.status).to eq('shipped')
      expect(order_1.shipped?).to eq(true)
    end
  end

end
