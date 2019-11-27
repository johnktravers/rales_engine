class Api::V1::Items::SalesController < ApplicationController

  def index
    if params[:quantity] && params[:quantity].to_i > 0
      items = Item.top_items_by_quantity_sold(params[:quantity].to_i)
      serialized_items = ItemSerializer.new(items)
      render json: serialized_items
    else
      render_error('Please input an integer quantity that is greater than 0.')
    end
  end

end
