class CategoriesController < ApplicationController
  before_filter :authenticate_user!

  def index

  end

  def load
    field = params[:field].nil? ? 'name' : params[:field]
    direction = params[:direction].nil? ? 'asc' : params[:direction]

    sort_str = "#{field} #{direction}"

    @categories = Category.enabled.order(sort_str).where('user_id = ?', current_user.id)
    render :partial => 'categories'
  end

  def new
    @category = Category.new({:amount => 0, :enabled => true, :user_id => current_user.id})
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(params[:category])
    respond_to do |format|
      if @category.save
        flash[:notice] = I18n.t('notice.category.added')
        format.html {redirect_to categories_path}
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @category = Category.find(params[:id])
    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = I18n.t('notice.category.changed')
        format.html {redirect_to categories_path}
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    if Category.find(params[:id]).update_attribute(:enabled, false)
      flash[:notice] = I18n.t('notice.category.deleted')
    else
      flash[:error] = I18n.t('error.category.deleted')
    end

    render :json => {:delete => true}
  end
end
