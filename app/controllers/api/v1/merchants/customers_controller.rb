class Api::V1::Merchants::CustomersController < ApplicationController

  def show
    merchant = Merchant.find_by(id: params[:id])
    if merchant
      customer = merchant.favorite_customer
      serialized_customer = CustomerSerializer.new(customer)
      render json: serialized_customer
    else
      render_show_error('Merchant')
    end
  end

end
