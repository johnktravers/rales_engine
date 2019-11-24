class Api::V1::Transactions::InvoicesController < ApplicationController

  def show
    transaction = Transaction.find_by(id: params[:id])

    if transaction
      serialized_invoice = InvoiceSerializer.new(transaction.invoice)
      render json: serialized_invoice
    else
      render_show_error('Transaction')
    end
  end

end
