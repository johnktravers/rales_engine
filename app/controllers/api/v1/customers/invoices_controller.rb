class Api::V1::Customers::InvoicesController < ApplicationController

  def index
    customer = Customer.find_by(id: params[:id])

    if customer && customer.invoices.any?
      serialized_invoices = InvoiceSerializer.new(customer.invoices)
      render json: serialized_invoices
    elsif customer
      render_relationship_error('Customer', 'invoices')
    else
      render_show_error('Customer')
    end
  end

end
