class Api::V1::Invoices::CustomersController < ApplicationController

  def show
    invoice = Invoice.find_by(id: params[:id])

    if invoice
      serialized_customer = CustomerSerializer.new(invoice.customer)
      render json: serialized_customer
    else
      render_show_error('Invoice')
    end
  end

end
