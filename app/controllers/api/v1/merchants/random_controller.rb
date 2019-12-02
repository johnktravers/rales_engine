class Api::V1::Merchants::RandomController < ApplicationController

  def show
    merchant = Merchant.random
    serialized_merchant = MerchantSerializer.new(merchant)
    render json: serialized_merchant
  end

end
