class ItemSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :merchant_id, :name, :description

  attribute :unit_price do |item|
    item.unit_price.to_s
  end
end
