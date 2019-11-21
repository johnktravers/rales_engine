class Api::V1::Merchants::RevenueController < ApplicationController

  def index
    if params[:quantity] && params[:quantity].to_i > 0
      merchants = Merchant.top_merchants_by_revenue(params[:quantity])
      serialized_merchants = MerchantSerializer.new(merchants)
      render json: serialized_merchants
    else
      render_error('Please input an integer quantity that is greater than 0.')
    end
  end

  def show
    if params[:date] && validate_date(params[:date])
      revenue = Invoice.total_revenue_on_date(params[:date])
      render json: { data: {
        id: params[:date].gsub(/-/, ''),
        type: 'revenue',
        attributes: { total_revenue: '%.2f' % revenue }
      } }
    else
      render_error('Incorrect date format. Please use format YYYY-MM-DD.')
    end
  end


  private

  def validate_date(date)
    (DateTime.parse(date) rescue ArgumentError) != ArgumentError
  end

end
