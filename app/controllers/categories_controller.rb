class CategoriesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @field = session["category_field"]
    @direction = session["category_direction"]
  end

  def sort
    field = params[:field].nil? ? "name" : params[:field]
    direction = params[:direction].nil? ? "asc" : params[:direction]

    session["category_field"] = field
    session["category_direction"] = direction

    sortStr = field + " " + direction

    @categories = Category.order(sortStr).find_all_by_user_id_and_enabled(current_user.id, true)
    render :partial => "categories"
  end

  def new
    @category = Category.new
    @category.amount = 0;
    @category.enabled = true;
  end

  def edit
    @category = Category.find(params[:id])
    if(@category.user_id != current_user.id)
      redirect_to :back and return
    end
  end

  def create
    @category = Category.new(params[:category])
    @category.user = current_user
    respond_to do |format|
      if @category.save
        flash[:notice] = I18n.t('notice.category.added')
        format.html {redirect_to categories_path}
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @category = Category.find(params[:id])
    if(@category.nil? || @category.user_id != current_user.id)
      render_404
    end

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = I18n.t('notice.category.changed')
        format.html {redirect_to categories_path}
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if(@category.user_id == current_user.id)
      @category.update_attribute(:enabled, false)
      if @category.save
        flash[:notice] = I18n.t('notice.category.deleted')
      else
        flash[:error] = I18n.t('error.category.deleted')
      end
    else
      flash[:error] = I18n.t('error.category.deleted')
    end
    redirect_to :back and return
  end
end
