class Api::V1::Customers::TransactionsController < ApplicationController

  def index
    customer = Customer.find_by(id: params[:id])

    if customer && customer.transactions.any?
      serialized_transactions = TransactionSerializer.new(customer.transactions)
      render json: serialized_transactions
    elsif customer
      render_relationship_error('Customer', 'transactions')
    else
      render_show_error('Customer')
    end
  end

end
