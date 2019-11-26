class Api::V1::Customers::SearchController < ApplicationController

  def show
    customers = Customer.where(filter_params)

    if customers.any?
      serialized_customer = CustomerSerializer.new(customers.first)
      render json: serialized_customer
    else
      render_find_error('Customer')
    end
  end

  def index
    customers = Customer.where(filter_params)

    if customers.any?
      serialized_customers = CustomerSerializer.new(customers)
      render json: serialized_customers
    else
      render_find_all_error('Customer')
    end
  end


  private

  def filter_params
    params.permit(:id, :first_name, :last_name, :created_at, :updated_at)
  end

end
