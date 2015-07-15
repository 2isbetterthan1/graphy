require 'csv'
class HistoricalQuotesLoaderController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def index
  end

  def load
    stock_data = mount_array
    respond_to do |format|
      format.json { render json: stock_data }
      format.html { render action: chart } #nao funcionou
    end
  end

  def chart
  end

  def mount_array
    stock_data = []
    single_information = []
    # stock_code = params[:stock_code]
    # start_month = (params[:start_month].to_i - 1).to_s
    # start_day = params[:start_day]
    # start_year = params[:starT_year]
    # end_month = (params[:end_month].to_i - 1).to_s
    # end_day = params[:end_day]
    # end_year = params[:end_year]
    stock_code = 'PETR4.SA'
    start_month = '06'
    start_day = '01'
    start_year = '2015'
    end_month = '06'
    end_day = '14'
    end_year = '2015'

    response = RestClient.get 'http://real-chart.finance.yahoo.com/table.csv',
      { params: {
        s: stock_code,
        a: start_month,
        b: start_day,
        c: start_year,
        d: end_month,
        e: end_day,
        f: end_year,
        g: 'd',
        ignore: '.csv'
        }
      }
    table = response.body

    stock_data << %w(date value)
    CSV.parse(table, headers: true) do |row|
      single_information = [row['Date'], row['Close'].to_f]
      stock_data << single_information
    end
    stock_data
  end
end
