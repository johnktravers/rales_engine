class Api::V1::MerchantsController < ApplicationController

  def index
    merchants = Merchant.all
    serialized_merchants = MerchantSerializer.new(merchants)
    render json: serialized_merchants
  end

  def show
    merchant = Merchant.find_by(id: params[:id])
    if merchant
      serialized_merchant = MerchantSerializer.new(merchant)
      render json: serialized_merchant
    else
      render_show_error('Merchant')
    end
  end

end
