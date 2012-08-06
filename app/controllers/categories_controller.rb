class CategoriesController < ApplicationController
  before_filter :authenticate_user!

  def index

  end

  def load
    field = params[:field].nil? ? "name" : params[:field]
    direction = params[:direction].nil? ? "asc" : params[:direction]
    sortStr = field + " " + direction

    @categories = Category.order(sortStr).find_all_by_user_id_and_enabled(current_user.id, true)
    render :partial => "categories"
  end

  def sort
    respond_to do |format|
      format.html { redirect_to load_categories_path(:field => params[:field], :direction => params[:direction])}
    end
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
    if(current_user.nil? == false)
      @category.user = current_user
      respond_to do |format|
        if @category.save
          format.html {redirect_to categories_path}
        else
          format.html { render action: "new" }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    @category = Category.find(params[:id])
    if(@category.user_id == current_user.id)
      respond_to do |format|
        if @category.update_attributes(params[:category])
          format.html {redirect_to categories_path}
        else
          format.html { render action: "edit" }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to :back and return
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if(@category.user_id == current_user.id)
      @category.update_attribute(:enabled, false)
      @category.save
      respond_to do |format|
        format.html { redirect_to categories_url }
        format.json { head :no_content }
      end
    else
      redirect_to :back and return
    end
  end
end
