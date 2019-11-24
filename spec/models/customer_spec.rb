require 'rails_helper'

RSpec.describe Customer, type: :model do

  describe 'validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
  end

  describe 'class methods' do
    it 'random customer' do
      customers = create_list(:customer, 3)

      expect(Customer.random_customer)
        .to eq(customers[0]).or eq(customers[1]).or eq(customers[2])
    end
  end

end
