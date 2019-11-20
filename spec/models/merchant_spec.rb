require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
  end

  describe 'class methods' do
    it 'random merchant' do
      merchants = create_list(:merchant, 3)

      expect(Merchant.random_merchant)
        .to eq(merchants[0]).or eq(merchants[1]).or eq(merchants[2])
    end
  end

end
