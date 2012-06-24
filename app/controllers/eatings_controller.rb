class EatingsController < ApplicationController
  # GET /eatings
  # GET /eatings.json
  def index
    @eatings = Eating.all

    respond_to do |format|
      format.html # _eatings.html.erb
      format.json { render json: @eatings }
    end
  end

  # GET /eatings/1
  # GET /eatings/1.json
  def show
    @eating = Eating.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @eating }
    end
  end

  # GET /eatings/new
  # GET /eatings/new.json
  def new
    @eating = Eating.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @eating }
    end
  end

  # GET /eatings/1/edit
  def edit
    @eating = Eating.find(params[:id])
  end

  # POST /eatings
  # POST /eatings.json
  def create
    @eating = Eating.new(params[:eating])

    respond_to do |format|
      if @eating.save
        format.html { redirect_to @eating, notice: 'Eating was successfully created.' }
        format.json { render json: @eating, status: :created, location: @eating }
      else
        format.html { render action: "new" }
        format.json { render json: @eating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /eatings/1
  # PUT /eatings/1.json
  def update
    @eating = Eating.find(params[:id])

    respond_to do |format|
      if @eating.update_attributes(params[:eating])
        format.html { redirect_to @eating, notice: 'Eating was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @eating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eatings/1
  # DELETE /eatings/1.json
  def destroy
    @eating = Eating.find(params[:id])
    @eating.destroy

    respond_to do |format|
      format.html { redirect_to eatings_url }
      format.json { head :no_content }
    end
  end
end
