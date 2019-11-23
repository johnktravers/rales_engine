class Api::V1::InvoiceItems::InvoicesController < ApplicationController

  def show
    invoice_item = InvoiceItem.find_by(id: params[:id])

    if invoice_item
      serialized_invoice = InvoiceSerializer.new(invoice_item.invoice)
      render json: serialized_invoice
    else
      render_show_error('Invoice item')
    end
  end

end
