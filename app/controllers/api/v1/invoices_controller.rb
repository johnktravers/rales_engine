class Api::V1::InvoicesController < ApplicationController

  def index
    invoices = Invoice.all
    serialized_invoices = InvoiceSerializer.new(invoices)
    render json: serialized_invoices
  end

  def show
    invoice = Invoice.find_by(id: params[:id])
    if invoice
      serialized_invoice = InvoiceSerializer.new(invoice)
      render json: serialized_invoice
    else
      render_show_error('Invoice')
    end
  end

end
