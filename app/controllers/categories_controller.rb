class CategoriesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @field = session['category_field']
    @direction = session['category_direction']
  end

  def load
    session['category_field'] = params[:field].nil? ? 'name' : params[:field]
    session['category_direction'] = params[:direction].nil? ? 'asc' : params[:direction]

    sort_str = "#{session['category_field']} #{session['category_direction']}"

    @categories = Category.order(sort_str).find_all_by_user_id_and_enabled(current_user.id, true)
    render :partial => 'categories'
  end

  def new
    @category = Category.new({:amount => 0, :enabled => true})
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(params[:category])
    @category.user = current_user
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
    redirect_to :back
  end
end
