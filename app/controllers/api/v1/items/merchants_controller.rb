class Api::V1::Items::MerchantsController < ApplicationController

  def show
    item = Item.find_by(id: params[:id])

    if item
      serialized_merchant = MerchantSerializer.new(item.merchant)
      render json: serialized_merchant
    else
      render_show_error('Item')
    end
  end

end
