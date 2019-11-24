class Api::V1::Transactions::RandomController < ApplicationController

  def show
    transaction = Transaction.random_transaction
    serialized_transaction = TransactionSerializer.new(transaction)
    render json: serialized_transaction
  end

end
