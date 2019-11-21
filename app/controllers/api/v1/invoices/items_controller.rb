class Api::V1::Invoices::ItemsController < ApplicationController

  def index
    invoice = Invoice.find_by(id: params[:id])

    if invoice && invoice.items.any?
      serialized_items = ItemSerializer.new(invoice.items)
      render json: serialized_items
    elsif invoice
      render_relationship_error('Invoice', 'items')
    else
      render_show_error('Invoice')
    end
  end

end
