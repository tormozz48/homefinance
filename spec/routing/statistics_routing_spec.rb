require 'spec_helper'

describe StatisticsController do
  describe 'routing' do

    it 'statistic index' do
      get('/statistics').should route_to('statistics#index')
    end

    it 'show statistic by date' do
      get('/statistics/load_by_date').should route_to('statistics#load_by_date')
    end

    it 'show statistic by category' do
      get('/statistics/load_by_category').should route_to('statistics#load_by_category')
    end
  end
end