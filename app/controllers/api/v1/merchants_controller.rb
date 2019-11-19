class Api::V1::MerchantsController < ApplicationController

  def index
    merchants = Merchant.all
    serialized_merchants = MerchantSerializer.new(merchants)
    render json: serialized_merchants
  end

  def show
    merchant = Merchant.find(params[:id])
    serialized_merchant = MerchantSerializer.new(merchant)
    render json: serialized_merchant
  end

end
