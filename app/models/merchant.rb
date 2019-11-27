class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :customers,     through: :invoices
  has_many :transactions,  through: :invoices
  has_many :invoice_items, through: :invoices

  def self.random_merchant
    find(pluck(:id).sample)
  end

  def self.top_merchants_by_revenue(limit)
    find_by_sql(
      'SELECT merchants.*
        FROM merchants
        INNER JOIN invoices ON invoices.merchant_id = merchants.id
        INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id
        INNER JOIN transactions ON transactions.invoice_id = invoices.id
        WHERE transactions.result = 0
        GROUP BY merchants.id
        ORDER BY sum(invoice_items.quantity * invoice_items.unit_price) DESC
        LIMIT ($1)', [[nil, limit]]
    )
  end

  def self.top_merchants_by_items_sold(limit)
    find_by_sql(
      'SELECT merchants.*
        FROM merchants
        INNER JOIN invoices ON invoices.merchant_id = merchants.id
        INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id
        INNER JOIN transactions ON transactions.invoice_id = invoices.id
        WHERE transactions.result = 0
        GROUP BY merchants.id
        ORDER BY sum(invoice_items.quantity) DESC
        LIMIT ($1)', [[nil, limit]]
    )
  end

  def favorite_customer
    customers
    .joins(:transactions)
    .select('customers.*, count(transactions.id)')
    .merge(Transaction.successful)
    .where(invoices: {merchant_id: id})
    .group('customers.id')
    .order('count DESC')
    .first
  end

  def total_revenue
    items
      .joins(:transactions)
      .merge(Transaction.successful)
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def total_revenue_on_date(date)
    items
      .joins(:transactions)
      .merge(Transaction.successful)
      .where('invoices.created_at::date = ?', date)
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
