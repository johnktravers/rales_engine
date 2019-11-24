class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name

  has_many :invoices
  has_many :merchants,     through: :invoices
  has_many :transactions,  through: :invoices
  has_many :invoice_items, through: :invoices

  def self.random_customer
    find(pluck(:id).sample)
  end

  def favorite_merchant
    merchants
      .joins(:transactions)
      .select('merchants.*, count(transactions.id)')
      .merge(Transaction.successful)
      .group('merchants.id')
      .order('count DESC')
      .first
  end
end
