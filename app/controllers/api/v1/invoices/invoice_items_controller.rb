class Api::V1::Invoices::InvoiceItemsController < ApplicationController

  def index
    invoice = Invoice.find_by(id: params[:id])

    if invoice && invoice.invoice_items.any?
      serialized_invoice_items = InvoiceItemSerializer.new(invoice.invoice_items)
      render json: serialized_invoice_items
    elsif invoice
      render_relationship_error('Invoice', 'invoice_items')
    else
      render_show_error('Invoice')
    end
  end

end
