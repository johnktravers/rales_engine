class Api::V1::Invoices::RandomController < ApplicationController

  def show
    invoice = Invoice.random
    serialized_invoice = InvoiceSerializer.new(invoice)
    render json: serialized_invoice
  end

end
