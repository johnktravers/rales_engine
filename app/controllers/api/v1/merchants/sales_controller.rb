class Api::V1::Merchants::SalesController < ApplicationController

  def index
    if params[:quantity] && params[:quantity].to_i > 0
      merchants = Merchant.top_merchants_by_items_sold(params[:quantity].to_i)
      serialized_merchants = MerchantSerializer.new(merchants)
      render json: serialized_merchants
    else
      render_error('Please input an integer quantity that is greater than 0.')
    end
  end

end
