class Api::V1::InvoiceItems::RandomController < ApplicationController

  def show
    invoice_item = InvoiceItem.random_invoice_item
    serialized_invoice_item = InvoiceItemSerializer.new(invoice_item)
    render json: serialized_invoice_item
  end

end
