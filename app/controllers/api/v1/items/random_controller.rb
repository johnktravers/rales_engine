class Api::V1::Items::RandomController < ApplicationController

  def show
    item = Item.random
    serialized_item = ItemSerializer.new(item)
    render json: serialized_item
  end

end
