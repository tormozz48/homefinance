class StatisticsController < ApplicationController
  before_filter :authenticate_user!

  DATE_FROM_DEFAULT = 1.month.ago.to_date

  def index
    @date_from = session[:date_from] || DATE_FROM_DEFAULT
    @date_to = session[:date_to] || Date.today
  end

  def load_by_category
    date_from = params[:date_from]
    date_to = params[:date_to]

    transactions = Transaction
    .where(:date => (date_from.to_date)..(date_to.to_date),
           :enabled => true,
           :user_id => current_user.id)
    .select('categories.name, categories.color, sum(transactions.amount) as amount')
    .joins('inner join categories on categories.id = transactions.category_id')
    .group('categories.name, categories.color')
    .having('sum(transactions.amount) > 0')
    .order('amount desc').collect do |tr|{
          category: tr.name,
          value: tr.amount,
          color: "##{tr.color}"}
    end

    session[:date_from] = date_from
    session[:date_to] = date_to

    render :json => transactions, :content_type => 'application/json'
  end

  def load_by_date
    date_from = params[:date_from]
    date_to = params[:date_to]

    type = params[:type] || Transaction::TR_FROM_CASH_TO_CATEGORY

    transactions = Transaction.where(
                  :date => (date_from.to_date)..(date_to.to_date),
                  :transaction_type => type,
                  :enabled => true,
                  :user_id => current_user.id)
    .select('date(date), sum(amount) as value')
    .group('date(date)').order('date asc').having('sum(amount) > 0')

    session[:date_from] = date_from
    session[:date_to] = date_to

    render :json => transactions, :content_type => 'application/json'
  end
end
