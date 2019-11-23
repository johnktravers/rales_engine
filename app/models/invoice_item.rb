class InvoiceItem < ApplicationRecord
  validates :quantity,
    presence: true,
    numericality: { only_integer: true }

  validates :unit_price,
    presence: true,
    numericality: { greater_than: 0 }

  belongs_to :item
  belongs_to :invoice

  def self.random_invoice_item
    find(pluck(:id).sample)
  end
end
