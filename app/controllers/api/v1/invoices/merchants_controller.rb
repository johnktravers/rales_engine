class Api::V1::Invoices::MerchantsController < ApplicationController

  def show
    invoice = Invoice.find_by(id: params[:id])

    if invoice
      serialized_merchant = MerchantSerializer.new(invoice.merchant)
      render json: serialized_merchant
    else
      render_show_error('Invoice')
    end
  end

end
