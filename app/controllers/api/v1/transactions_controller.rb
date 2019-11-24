class Api::V1::TransactionsController < ApplicationController

  def index
    transactions = Transaction.all
    serialized_transactions = TransactionSerializer.new(transactions)
    render json: serialized_transactions
  end

  def show
    transaction = Transaction.find_by(id: params[:id])
    if transaction
      serialized_transaction = TransactionSerializer.new(transaction)
      render json: serialized_transaction
    else
      render_show_error('Transaction')
    end
  end

end
