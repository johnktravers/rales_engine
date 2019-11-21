class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :transactions,  through: :invoices
  has_many :invoice_items, through: :invoices

  def self.random_merchant
    find(pluck(:id).sample)
  end
end
