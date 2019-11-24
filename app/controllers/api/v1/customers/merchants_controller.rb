class Api::V1::Customers::MerchantsController < ApplicationController

  def show
    customer = Customer.find_by(id: params[:id])

    if customer
      merchant = customer.favorite_merchant
      serialized_merchant = MerchantSerializer.new(merchant)
      render json: serialized_merchant
    else
      render_show_error('Customer')
    end
  end

end
