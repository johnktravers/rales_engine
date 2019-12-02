class Invoice < ApplicationRecord
  validates_presence_of :status
  enum status: %w(shipped)

  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def self.total_revenue_on_date(date)
    joins(:invoice_items, :transactions)
      .merge(Transaction.successful)
      .where('invoices.created_at::date = ?', date)
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def self.best_day(item_id)
    ActiveRecord::Base.connection.exec_query(
      'SELECT invoices.created_at::date, sum(invoice_items.quantity)
        FROM invoice_items
        INNER JOIN invoices ON invoice_items.invoice_id = invoices.id
        INNER JOIN transactions ON invoices.id = transactions.invoice_id
        WHERE transactions.result = 0 AND invoice_items.item_id = ($1)
        GROUP BY invoices.created_at::date
        ORDER BY sum DESC, invoices.created_at::date DESC
        LIMIT 1', 'item best day', [[nil, item_id]]
    ).rows[0]
  end
end
