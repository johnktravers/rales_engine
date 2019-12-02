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
    it 'can be created as a successful transaction' do
      transaction = create(:transaction)

      expect(transaction.result).to eq('success')
      expect(transaction.success?).to eq(true)
    end

    it 'can be created as a successful transaction' do
      transaction = create(:transaction, result: 1)

      expect(transaction.result).to eq('failed')
      expect(transaction.failed?).to eq(true)
    end
  end

  describe 'class methods' do
    it 'random transaction' do
      transactions = create_list(:transaction, 3)

      expect(Transaction.random)
        .to eq(transactions[0])
        .or eq(transactions[1])
        .or eq(transactions[2])
    end
  end

end
