require 'rails_helper'

RSpec.describe 'Items API - business intelligence endpoints' do

  describe 'successful endpoint data retrieval' do
    before :each do
      [0, 1, 2].each do |i|
        create_list(:invoice, 5, created_at: "2012-03-#{i}4 15:54:10 UTC")
      end

      @items = create_list(:item, 3)

      Invoice.all.each_with_index do |invoice, i|
        create(:invoice_item, invoice: invoice, unit_price: (i + 1) * 10 % 43, item: @items[i % 3], quantity: i)
        create(:transaction, invoice: invoice, result: (i.even? ? 0 : 1))
      end
    end

    it 'shows the top items by revenue' do
      get '/api/v1/items/most_revenue?quantity=2'

      expect(response).to be_successful

      json_items = JSON.parse(response.body)

      expect(json_items['data'].length).to eq(2)
      expect(json_items['data'][0]['id'].to_i).to eq(@items[2].id)
      expect(json_items['data'][1]['id'].to_i).to eq(@items[1].id)
    end

    it 'shows the top item by quantity sold' do
      get '/api/v1/items/most_items?quantity=2'

      expect(response).to be_successful

      json_items = JSON.parse(response.body)

      expect(json_items['data'].length).to eq(2)
      expect(json_items['data'][0]['id'].to_i).to eq(@items[2].id)
      expect(json_items['data'][1]['id'].to_i).to eq(@items[0].id)
    end

    it 'shows the date with the most sales for a given item' do
      get "/api/v1/items/#{@items[0].id}/best_day"

      expect(response).to be_successful

      date = JSON.parse(response.body)

      expect(date['data']['attributes']['best_day'])
        .to eq('2012-03-24')
    end
  end

  describe 'endpoint error handling' do
    it 'shows an error if the quantity is not a valid integer' do
      paths = ['most_revenue', 'most_items']

      paths.each do |path|
        get "/api/v1/items/#{path}?quantity=-4"

        expect(response).to be_successful

        error = JSON.parse(response.body)

        expect(error['errors'][0]['title'])
          .to eq('Please input an integer quantity that is greater than 0.')
      end
    end

    it 'shows an error if the item does not exist' do
      get '/api/v1/items/1/best_day'

      expect(response).to be_successful

      error = JSON.parse(response.body)

      expect(error['errors'][0]['title'])
        .to eq('Item with given ID does not exist.')
    end
  end

end
