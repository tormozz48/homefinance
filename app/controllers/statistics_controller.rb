class StatisticsController < ApplicationController
  before_filter :authenticate_user!

  def getStatisticByDate

    respond_to do |format|
      format.html {render 'statistics/index'}
    end
  end

  def getStatisticByCategory

    respond_to do |format|
      format.html {render 'statistics/index'}
    end
  end

end
