class Api::V1::Items::InvoiceItemsController < ApplicationController

  def index
    item = Item.find_by(id: params[:id])

    if item && item.invoice_items.any?
      serialized_invoice_items = InvoiceItemSerializer.new(item.invoice_items)
      render json: serialized_invoice_items
    elsif item
      render_relationship_error('Item', 'invoice items')
    else
      render_show_error('Item')
    end
  end

end
