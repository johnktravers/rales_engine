class Api::V1::Merchants::ItemsController < ApplicationController

  def index
    merchant = Merchant.find_by(id: params[:id])

    if merchant && merchant.items.any?
      serialized_items = ItemSerializer.new(merchant.items)
      render json: serialized_items
    elsif merchant
      render_relationship_error('Merchant', 'items')
    else
      render_show_error('Merchant')
    end
  end

end
