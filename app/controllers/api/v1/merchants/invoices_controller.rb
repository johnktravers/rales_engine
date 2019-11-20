class Api::V1::Merchants::InvoicesController < ApplicationController

  def index
    merchant = Merchant.find_by(id: params[:id])

    if merchant && merchant.invoices.any?
      serialized_invoices = InvoiceSerializer.new(merchant.invoices)
      render json: serialized_invoices
    elsif merchant
      render_relationship_error('Merchant', 'invoices')
    else
      render_show_error('Merchant')
    end
  end

end
