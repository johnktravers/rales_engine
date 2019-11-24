class Api::V1::Items::DatesController < ApplicationController

  def show
    item = Item.find_by(id: params[:id])

    if item
      date = Invoice.best_day(item.id)
      render json: { data: {
        id: date[0].gsub(/-/, ''),
        type: 'date',
        attributes: { best_day: date[0], transaction_count: date[1].to_s }
      } }
    else
      render_show_error('Item')
    end
  end

end
