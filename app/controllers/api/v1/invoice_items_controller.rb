class Api::V1::InvoiceItemsController < ApplicationController

  def index
    invoice_items = InvoiceItem.all
    serialized_invoice_items = InvoiceItemSerializer.new(invoice_items)
    render json: serialized_invoice_items
  end

  def show
    invoice_item = InvoiceItem.find_by(id: params[:id])
    if invoice_item
      serialized_invoice_item = InvoiceItemSerializer.new(invoice_item)
      render json: serialized_invoice_item
    else
      render_show_error('Invoice item')
    end
  end

end
