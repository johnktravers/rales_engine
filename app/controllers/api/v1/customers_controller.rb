class Api::V1::CustomersController < ApplicationController

  def index
    customers = Customer.all
    serialized_customers = CustomerSerializer.new(customers)
    render json: serialized_customers
  end

  def show
    customer = Customer.find_by(id: params[:id])
    if customer
      serialized_customer = CustomerSerializer.new(customer)
      render json: serialized_customer
    else
      render_show_error('Customer')
    end
  end

end
