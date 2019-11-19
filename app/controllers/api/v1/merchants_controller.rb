class Api::V1::MerchantsController < ApplicationController

  def index
    merchants = Merchant.all
    serialized_merchants = MerchantSerializer.new(merchants)
    render json: serialized_merchants
  end

end
