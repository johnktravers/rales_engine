class Api::V1::Transactions::SearchController < ApplicationController

  def show
    transactions = Transaction.where(filter_params)

    if transactions.any?
      serialized_transaction = TransactionSerializer.new(transactions.first)
      render json: serialized_transaction
    else
      render_find_error('Transaction')
    end
  end

  def index
    transactions = Transaction.where(filter_params)

    if transactions.any?
      serialized_transactions = TransactionSerializer.new(transactions.order(:id))
      render json: serialized_transactions
    else
      render_find_all_error('Transaction')
    end
  end


  private

  def filter_params
    params.permit(
      :id,
      :invoice_id,
      :result,
      :credit_card_number,
      :created_at,
      :updated_at
    )
  end

end
