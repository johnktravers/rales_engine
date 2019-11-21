class Api::V1::Invoices::SearchController < ApplicationController

  def show
    invoices = Invoice.where(filter_params)

    if invoices.any?
      serialized_invoice = InvoiceSerializer.new(invoices.first)
      render json: serialized_invoice
    else
      render_find_error('Invoice')
    end
  end

  def index
    invoices = Invoice.where(filter_params)

    if invoices.any?
      serialized_invoices = InvoiceSerializer.new(invoices.order(:id))
      render json: serialized_invoices
    else
      render_find_all_error('Invoice')
    end
  end


  private

  def filter_params
    params.permit(:id, :status, :merchant_id, :customer_id, :created_at, :updated_at)
  end

end
