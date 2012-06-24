class WeightsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @weights = Weight.all
  end


  def show

  end


  def new
    @weight = Weight.new
    @weight.enabled = true
    @weight.training = false
    @weight.weight = 0
    @weight.date = Date.today
  end


  def edit
    @weight = Weight.find(params[:id])
  end


  def create
    @weight = Weight.new(params[:weight])

    respond_to do |format|
      if @weight.save
        format.html {redirect_to weights_path}
      else
        format.html { render action: "new" }
        format.json { render json: @weight.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @weight = Weight.find(params[:id])
    respond_to do |format|
      if @weight.update_attributes(params[:weight])
        format.html {redirect_to weights_path}
      else
        format.html { render action: "edit" }
        format.json { render json: @weight.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @weight = Weight.find(params[:id])
    @weight.destroy

    respond_to do |format|
      format.html { redirect_to weights_url }
      format.json { head :no_content }
    end
  end
end
