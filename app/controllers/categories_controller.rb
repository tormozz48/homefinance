class CategoriesController < ApplicationController
  before_filter :authenticate_user!

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.order("name asc").find_all_by_user_id_and_enabled(current_user.id, true)
    respond_to do |format|
      format.html
      format.json { render json: @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show

  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @category = Category.new
    @category.amount = 0;
    @category.enabled = true;
    respond_to do |format|
      format.html
      format.json { render json: @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    if(@category.user_id != current_user.id)
      redirect_to :back and return
    end
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(params[:category])
    if(current_user.nil? == false)
      @category.user = current_user
      #@category.amount = 0;
      #@category.enabled = true;
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

  # PUT /categories/1
  # PUT /categories/1.json
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

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    if(@category.user_id == current_user.id)
      @category.enabled = false
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
