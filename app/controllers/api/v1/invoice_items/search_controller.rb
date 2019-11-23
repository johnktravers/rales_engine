class Api::V1::InvoiceItems::SearchController < ApplicationController

  def show
    invoice_items = InvoiceItem.where(filter_params)

    if invoice_items.any?
      serialized_invoice_item = InvoiceItemSerializer.new(invoice_items.first)
      render json: serialized_invoice_item
    else
      render_find_error('Invoice item')
    end
  end

  def index
    invoice_items = InvoiceItem.where(filter_params)

    if invoice_items.any?
      serialized_invoice_items = InvoiceItemSerializer.new(invoice_items.order(:id))
      render json: serialized_invoice_items
    else
      render_find_all_error('Invoice item')
    end
  end


  private

  def filter_params
    params.permit(
      :id,
      :quantity,
      :unit_price,
      :item_id,
      :invoice_id,
      :created_at,
      :updated_at
    )
  end

end
