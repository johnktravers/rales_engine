class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :transactions,  through: :invoices
  has_many :invoice_items, through: :invoices

  def self.random_merchant
    find(pluck(:id).sample)
  end

  def self.top_merchants_by_revenue(limit)
    joins(:invoice_items, :transactions)
      .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
      .group(:id)
      .order('total_revenue DESC')
      .limit(limit)
  end
end
