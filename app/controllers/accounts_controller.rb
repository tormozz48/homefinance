class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @account_type = params[:type]
    @field = session['account_field']
    @direction = session['account_direction']
    unless Account::ACCOUNT_TYPES.include? @account_type.to_i
      render_404
    end
  end

  def load
    account_type = params[:type]
    field = params[:field].nil? ? 'name' : params[:field]
    direction = params[:direction].nil? ? 'asc' : params[:direction]

    session['category_field'] = field
    session['category_direction'] = direction

    sort_str = "#{field} #{direction}"

    @accounts = Account.order(sort_str).where('account_type = ? AND user_id = ? AND enabled = true', account_type, current_user.id)
    render :partial => 'accounts'
  end

  def new
    @account = Account.new({:account_type => params[:type], :amount => 0})
  end

  def edit
    @account = Account.find(params[:id])
  end

  def create
    @account = Account.new(params[:account])
    @account_type = @account.account_type
    @account.user = current_user
    respond_to do |format|
      if @account.save
        flash[:notice] = @account_type == Account::ACCOUNT_CARD_TYPE ?
            I18n.t('notice.account.added') : I18n.t('notice.cash.added')
        format.html {redirect_to accounts_path(:type=> @account_type)}
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @account = Account.find(params[:id])
    @account_type = @account.account_type
    respond_to do |format|
        if @account.update_attributes(params[:account])
          flash[:notice] = @account_type == Account::ACCOUNT_CARD_TYPE ?
              I18n.t('notice.account.changed') : I18n.t('notice.cash.changed')
          format.html { redirect_to accounts_path(:type=> @account_type) }
        else
          format.html { render action: 'edit' }
        end
    end
  end

  def destroy
    @account = Account.find(params[:id])
    account_type = @account.account_type
    if @account.update_attribute(:enabled, false)
      flash[:notice] = account_type == Account::ACCOUNT_CARD_TYPE ?
          I18n.t('notice.account.deleted') : I18n.t('notice.cash.deleted')
    else
      flash[:notice] = account_type == Account::ACCOUNT_CARD_TYPE ?
          I18n.t('error.account.deleted') : I18n.t('error.cash.deleted')
    end

    redirect_to :back
  end
end
