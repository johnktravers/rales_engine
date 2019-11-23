class Api::V1::InvoiceItems::ItemsController < ApplicationController

  def show
    invoice_item = InvoiceItem.find_by(id: params[:id])

    if invoice_item
      serialized_item = ItemSerializer.new(invoice_item.item)
      render json: serialized_item
    else
      render_show_error('Invoice item')
    end
  end

end
