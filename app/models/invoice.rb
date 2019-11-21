class Invoice < ApplicationRecord
  validates_presence_of :status
  enum status: %w(shipped)

  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :transactions

  def self.random_invoice
    find(pluck(:id).sample)
  end

  def self.total_revenue_on_date(date)
    joins(:invoice_items, :transactions)
      .where('invoices.created_at::date = ? AND transactions.result = 0', date)
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
