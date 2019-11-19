require 'rails_helper'

RSpec.describe Transaction, type: :model do

  describe 'validations' do
    it { should validate_presence_of :credit_card_number }
    it { should validate_presence_of :result }

    it { should validate_length_of(:credit_card_number).is_equal_to(16) }
    it { should validate_numericality_of(:credit_card_number).only_integer }
  end

  describe 'relationships' do
    it { should belong_to :invoice }
  end

  describe 'result' do
    before :each do
      @customer = Customer.create!(first_name: 'Chad', last_name: 'Belfort')
      @merchant = Merchant.create!(name: 'Once and Floral')
      @invoice = @customer.invoices.create!(merchant_id: @merchant.id, status: 0)
    end

    it 'can be created as a successful transaction' do
      transaction = @invoice.transactions.create!(
        credit_card_number: '4654405418249632',
        result: 0
      )

      expect(transaction.result).to eq('success')
      expect(transaction.success?).to eq(true)
    end

    it 'can be created as a successful transaction' do
      transaction = @invoice.transactions.create!(
        credit_card_number: '4654405418249632',
        result: 1
      )

      expect(transaction.result).to eq('failed')
      expect(transaction.failed?).to eq(true)
    end
  end

end
