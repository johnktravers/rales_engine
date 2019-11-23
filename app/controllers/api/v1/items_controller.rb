class Api::V1::ItemsController < ApplicationController

  def index
    items = Item.all
    serialized_items = ItemSerializer.new(items)
    render json: serialized_items
  end

  def show
    item = Item.find_by(id: params[:id])
    if item
      serialized_item = ItemSerializer.new(item)
      render json: serialized_item
    else
      render_show_error('Item')
    end
  end

end
