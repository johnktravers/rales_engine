class Transaction < ApplicationRecord
  validates_presence_of :result
  validates :credit_card_number,
    presence: true,
    numericality: { only_integer: true },
    length: { is: 16 }

  enum result: %w(success failed)

  belongs_to :invoice

  scope :successful, -> { where(result: 0) }
end
