class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name

  has_many :invoices
  has_many :merchants,     through: :invoices
  has_many :transactions,  through: :invoices
  has_many :invoice_items, through: :invoices

  def favorite_merchant
    merchants
      .joins(:transactions)
      .select('merchants.*, count(transactions.id)')
      .merge(Transaction.successful)
      .group('merchants.id')
      .order('count DESC')
      .first
  end

  def self.customers_with_pending_invoices(merchant_id)
    find_by_sql(
      'SELECT customers.*
        FROM customers
        INNER JOIN invoices ON invoices.customer_id = customers.id
        LEFT OUTER JOIN transactions ON invoices.id = transactions.invoice_id
        WHERE invoices.merchant_id = ($1)
        GROUP BY customers.id, invoices.id
        HAVING count(transactions.id) = sum(transactions.result)
          OR count(transactions.id) = 0', [[nil, merchant_id]]
    )
  end
end
