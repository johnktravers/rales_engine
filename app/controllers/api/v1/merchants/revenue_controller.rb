class Api::V1::Merchants::RevenueController < ApplicationController

  def index
    if params[:quantity] && params[:quantity].to_i > 0
      merchants = Merchant.top_merchants_by_revenue(params[:quantity].to_i)
      serialized_merchants = MerchantSerializer.new(merchants)
      render json: serialized_merchants
    else
      render_error('Please input an integer quantity that is greater than 0.')
    end
  end

  def show
    merchant = Merchant.find_by(id: params[:id]) if params[:id]

    if params[:id] && merchant && !params[:date]
      revenue = merchant.total_revenue
      id = params[:id]
      key = :revenue
    elsif params[:id] && merchant && params[:date] && validate_date(params[:date])
      revenue = merchant.total_revenue_on_date(params[:date])
      id = params[:id] + params[:date].gsub(/-/, '')
      key = :revenue
    elsif !params[:id] && params[:date] && validate_date(params[:date])
      revenue = Invoice.total_revenue_on_date(params[:date])
      id = params[:date].gsub(/-/, '')
      key = :total_revenue
    end

    if revenue
      render json: { data: {
        id: id,
        type: 'revenue',
        attributes: { key => '%.2f' % revenue }
        } }
    elsif params[:date] && !validate_date(params[:date])
      render_error('Incorrect date format. Please use format YYYY-MM-DD.')
    else
      render_show_error('Merchant')
    end

  end


  private

  def validate_date(date)
    (DateTime.parse(date) rescue ArgumentError) != ArgumentError
  end

end
