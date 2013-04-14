class TransactionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @transaction_type = params[:type]
    if @transaction_type.nil?
      @transaction_type = session['transaction_type']
      if @transaction_type.nil?
        @transaction_type = Transaction::TR_FROM_CASH_TO_CATEGORY
      else
        @transaction_type = @transaction_type.to_i
      end
    else
      @transaction_type = @transaction_type.to_i
    end
    if Transaction::TR_TYPES.include? @transaction_type
      @categories = Category.order_by_name.enabled.where('user_id = ?', current_user.id)

      @date_from = session['date_from'].nil? ? 1.week.ago.to_date : session['date_from']
      @date_to = session['date_to'].nil? ? Date.today : session['date_to']
      @category_id = session['category_id']

      @field = session['field']
      @direction = session['direction']
    else
      render_404
    end
  end

  def load
      transaction_type = params[:type]
      date_from = params[:date_from].nil? ? 1.year.ago.to_date : params[:date_from]
      date_to = params[:date_to].nil? ? Date.today : params[:date_to]
      category_id = params[:category]

      session['transaction_type'] = transaction_type
      session['date_from'] = date_from
      session['date_to'] = date_to
      session['category_id'] = category_id

      field = params[:field].nil? ? 'date' : params[:field]
      direction = params[:direction].nil? ? 'desc' : params[:direction]

      session['field'] = field
      session['direction'] = direction

      sort_str = "#{field} #{direction}, id DESC"

      if !category_id.nil? && !category_id.blank? && transaction_type.to_i.in?(Transaction::TR_GROUP_TO_CATEGORY)
        @transactions = Transaction.includes(:account_from, :account_to, :category).enabled.by_transaction_type(transaction_type)
                             .by_user(current_user.id).by_category(category_id).between_dates(date_from, date_to).order(sort_str)
      else
        @transactions = Transaction.includes(:account_from, :account_to, :category).enabled.by_transaction_type(transaction_type)
                             .by_user(current_user.id).between_dates(date_from, date_to).order(sort_str)
      end
      render :partial => 'transactions/transactions'
  end

  def new
    @task_new = true
    @transaction = Transaction.new({:transaction_type => params[:type], :amount => 0, :date => Date.today})
    load_advanced_data
  end

  def edit
    @task_new = false
    @transaction = Transaction.find(params[:id])
    load_advanced_data
  end

  def create
    @transaction = Transaction.new(params[:transaction])
    @transaction.user = current_user
    valid = @transaction.valid? ? @transaction.calculate_transaction_new : false
    respond_to do |format|
      if valid && @transaction.save
        flash[:notice] = I18n.t('notice.transaction.added')
        format.html {redirect_to transactions_path}
      else
        @task_new = true
        load_advanced_data
        format.html { render :action => 'new'}
      end
    end
  end

  def update
    @transaction = Transaction.find(params[:id])
    p = params[:transaction]
    @transaction.amount = p[:amount]
    valid = @transaction.valid? ? @transaction.calculate_transaction_edit : false
    respond_to do |format|
      if valid && @transaction.update_attributes(p)
        flash[:notice] = I18n.t('notice.transaction.changed')
        format.html {redirect_to transactions_path}
      else
        @task_new = false
        load_advanced_data
        format.html { render :action => 'edit'}
      end
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    valid = @transaction.valid? ? @transaction.calculate_transaction_destroy : false
    if valid && @transaction.destroy
      flash[:notice] = I18n.t('notice.transaction.deleted')
    else
      flash[:error] = I18n.t('error.transaction.deleted')
    end
    redirect_to transactions_path
  end
end

def load_advanced_data
  @accounts = Account.order_by_name.accounts.enabled.where('user_id = ?', current_user.id)
  @cashes = Account.order_by_name.cashes.enabled.where('user_id = ?', current_user.id)
  @categories = Category.order_by_name.enabled.where('user_id = ?', current_user.id)
end
