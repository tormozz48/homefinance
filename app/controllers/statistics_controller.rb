class StatisticsController < ApplicationController
  before_filter :authenticate_user!

  def initStatisticByDate
    @categories = Category.where("enabled = true").order("name asc")
    respond_to do |format|
      format.html {render 'statistics/statistic_date'}
    end
  end

  def initStatisticByCategory
    respond_to do |format|
      format.html {render 'statistics/statistic_category'}
    end
  end

  def showStatisticByDate
    date_from = params[:date_from]
    date_to = params[:date_to]
    transaction_type = params[:transaction_type]
    category_id = params[:category]
    if(!category_id.empty? &&
       (transaction_type == getTransactionFromAccountToCategory.to_s(10) ||
        transaction_type == getTransactionFromCashToCategory.to_s(10)))
          transactions = Transaction.where(
            :date => (date_from.to_date)..(date_to.to_date),
            :transaction_type => transaction_type,
            :enabled => true,
            :category_id => category_id,
            :user_id => current_user.id).select("date(date) as transaction_date, sum(amount) as transaction_amount")
              .group("date(date)").order("date asc").having("sum(amount) > 0")
    else
      transactions = Transaction.where(
          :date => (date_from.to_date)..(date_to.to_date),
          :transaction_type => transaction_type,
          :enabled => true,
          :user_id => current_user.id).select("date(date) as transaction_date, sum(amount) as transaction_amount")
                          .group("date(date)").order("date asc")

    end
    render :json=>[transactions]  and return
  end

  def showStatisticByCategory
    date_from = params[:date_from]
    date_to = params[:date_to]
    transaction_type = params[:transaction_type]
    transactions = Transaction.where(
        :date => (date_from.to_date)..(date_to.to_date),
        :transaction_type => transaction_type,
        :enabled => true,
        :user_id => current_user.id).select("categories.name as category_name, categories.color as category_color, sum(transactions.amount) as transaction_amount").
        joins('inner join categories on categories.id = transactions.category_id').group("categories.name, categories.color").order("transaction_amount desc").having("sum(transactions.amount) > 0")
    render :json=>[transactions]  and return
  end

end
