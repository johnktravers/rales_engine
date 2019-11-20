class Api::V1::Merchants::SearchController < ApplicationController

  def show
    merchants = Merchant.where(filter_params)

    if merchants.any?
      serialized_merchant = MerchantSerializer.new(merchants.first)
      render json: serialized_merchant
    else
      render_find_error('Merchant')
    end
  end


  private

  def filter_params
    params.permit(:id, :name, :created_at, :updated_at)
  end

end
