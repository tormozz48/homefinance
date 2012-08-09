class WeightsController < ApplicationController
  before_filter :authenticate_user!

  def index
    session[:page] = params[:page].nil? ? 1 : params[:page]
    @weights = Weight.order("date DESC").where("enabled = true and user_id = ?", current_user.id).page(session[:page])
  end

  def new
    last_record = Weight.where("enabled = true and user_id = ?", current_user.id).last

    @weight = Weight.new
    @weight.enabled = true
    @weight.training = false
    @weight.weight = last_record.nil? ? 0 : last_record.weight
    @weight.date = Date.today
  end

  def edit
    @weight = Weight.find(params[:id])
  end


  def create
    @weight = Weight.new(params[:weight])
    @weight.user_id=current_user.id
    respond_to do |format|
      if @weight.save
        format.html {redirect_to weights_path(:page => session[:page])}
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
        format.html {redirect_to weights_path(:page => session[:page])}
      else
        format.html { render action: "edit" }
        format.json { render json: @weight.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    weight = Weight.find(params[:id])
    weight.update_attribute(:enabled, false)
    weight.save

    respond_to do |format|
      format.html { redirect_to weights_path(:page => session[:page]) }
      format.json { head :no_content }
    end
  end

  def initStatisticWeight
    respond_to do |format|
      format.html {render 'weights/statistic'}
    end
  end

  def showStatisticWeight
    date_from = params[:date_from]
    date_to = params[:date_to]
    weights = Weight.where(
        :date => (date_from.to_date)..(date_to.to_date),
        :enabled => true,
        :user_id => current_user.id).select("date, weight").order("date asc")
    render :json=>[weights]  and return
  end
end
