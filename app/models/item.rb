class Item < ApplicationRecord
  validates_presence_of :name, :description
  validates :unit_price,
    presence: true,
    numericality: { greater_than: 0 }

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.random_item
    find(pluck(:id).sample)
  end
end
