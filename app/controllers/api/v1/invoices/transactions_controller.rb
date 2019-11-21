class Api::V1::Invoices::TransactionsController < ApplicationController

  def index
    invoice = Invoice.find_by(id: params[:id])

    if invoice && invoice.transactions.any?
      serialized_transactions = TransactionSerializer.new(invoice.transactions)
      render json: serialized_transactions
    elsif invoice
      render_relationship_error('Invoice', 'transactions')
    else
      render_show_error('Invoice')
    end
  end

end
