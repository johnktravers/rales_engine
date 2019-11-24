class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name

  has_many :invoices
  has_many :merchants,     through: :invoices
  has_many :transactions,  through: :invoices
  has_many :invoice_items, through: :invoices

  def self.random_customer
    find(pluck(:id).sample)
  end
end
