class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :invoices

  def self.random_merchant
    find(pluck(:id).sample)
  end
end
