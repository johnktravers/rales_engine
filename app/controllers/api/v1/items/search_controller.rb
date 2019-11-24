class Api::V1::Items::SearchController < ApplicationController

  def show
    items = Item.where(filter_params)

    if items.any?
      serialized_item = ItemSerializer.new(items.first)
      render json: serialized_item
    else
      render_find_error('Item')
    end
  end

  def index
    items = Item.where(filter_params)

    if items.any?
      serialized_items = ItemSerializer.new(items.order(:id))
      render json: serialized_items
    else
      render_find_all_error('Item')
    end
  end


  private

  def filter_params
    params.permit(
      :id,
      :name,
      :description,
      :unit_price,
      :merchant_id,
      :created_at,
      :updated_at
    )
  end

end
