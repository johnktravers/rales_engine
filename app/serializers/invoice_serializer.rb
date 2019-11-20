class InvoiceSerializer
  include FastJsonapi::ObjectSerializer

  attributes :status

  attribute :merchant_id do |invoice|
    invoice.merchant_id.to_s
  end
end
