class Item < ApplicationRecord
  validates_presence_of :name, :description
  validates :unit_price,
    presence: true,
    numericality: { greater_than: 0 }

  belongs_to :merchant
end
