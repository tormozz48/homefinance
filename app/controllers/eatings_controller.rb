class EatingsController < ApplicationController
  before_filter :authenticate_user!

  def index

  end

  def show

  end

  def new
    weight_id = params[:weight_id]
    @eating = Eating.new
    @eating.enabled = true
    @eating.time=Time.now
    @eating.weight_id = weight_id
    @eating.overweight=false
    @eating.violation=false

    @eating_types = EatingType.order("eating_order").where("enabled = true")
    if (@eating_types.nil? || @eating_types.length == 0)
      eating_type_breakfast = EatingType.new(:name => I18n.t(:eating_type_breakfast), :eating_order => 0, :enabled => true )
      eating_type_breakfast.save
      eating_type_lunch1 = EatingType.new(:name => I18n.t(:eating_type_lunch1), :eating_order => 1, :enabled => true )
      eating_type_lunch1.save
      eating_type_afternoon = EatingType.new(:name => I18n.t(:eating_type_afternoon), :eating_order => 2, :enabled => true )
      eating_type_afternoon.save
      eating_type_lunch2 = EatingType.new(:name => I18n.t(:eating_type_lunch2), :eating_order => 3, :enabled => true )
      eating_type_lunch2.save
      eating_type_dinner = EatingType.new(:name => I18n.t(:eating_type_dinner), :eating_order => 4, :enabled => true )
      eating_type_dinner.save
      eating_type_additional = EatingType.new(:name => I18n.t(:eating_type_additional), :eating_order => 5, :enabled => true )
      eating_type_additional.save
      @eating_types = EatingType.order("eating_order").where("enabled = true")
    end
  end

  def edit
    @eating = Eating.find(params[:id])
    @eating_types = EatingType.order("eating_order").where("enabled = true")
  end

  def create
    @eating = Eating.new(params[:eating])
    if @eating.overweight.nil?
      @eating.overweight=false
    end
    if @eating.violation.nil?
      @eating.violation=false
    end

    respond_to do |format|
      if @eating.save
        format.html { redirect_to weights_path }
      else
        @eating_types = EatingType.order("eating_order").where("enabled = true")
        format.html { render action: "new" }
        format.json { render json: [@eating.errors, @eating_types], status: :unprocessable_entity }
      end
    end
  end

  def update
    @eating = Eating.find(params[:id])

    respond_to do |format|
      if @eating.update_attributes(params[:eating])
        format.html { redirect_to weights_path }
      else
        format.html { render action: "edit" }
        format.json { render json: @eating.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @eating = Eating.find(params[:id])
    @eating.destroy

    respond_to do |format|
      format.html { redirect_to weights_path }
      format.json { head :no_content }
    end
  end
end
