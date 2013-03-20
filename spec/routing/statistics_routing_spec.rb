require 'spec_helper'

describe StatisticsController do
  describe 'routing' do

    it 'statistic date' do
      get('/statistics/statistic_date').should route_to('statistics#statistic_date')
    end

    it 'statistic category' do
      get('/statistics/statistic_category').should route_to('statistics#statistic_category')
    end

    it 'show statistic by date' do
      post('/statistics/show_statistic_by_date').should route_to('statistics#show_statistic_by_date')
    end

    it 'show statistic by category' do
      post('/statistics/show_statistic_by_category').should route_to('statistics#show_statistic_by_category')
    end
  end
end