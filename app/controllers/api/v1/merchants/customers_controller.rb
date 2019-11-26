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

  def index
    merchant = Merchant.find_by(id: params[:id])

    if merchant
      customers = Customer.order(:id).customers_with_pending_invoices(merchant.id)
      serialized_customers = CustomerSerializer.new(customers)
      render json: serialized_customers
    else
      render_show_error('Merchant')
    end
  end

end
