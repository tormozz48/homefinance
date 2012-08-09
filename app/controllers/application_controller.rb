class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!, :only => [:edit, :update]

  def edit
    @user = current_user
    respond_to do |format|
      format.html {render 'devise/user_profile'}
    end
  end

  def update
      @user = User.find(current_user.id)
      successfully_updated = @user.update_without_password(params[:user])
      if successfully_updated
        sign_in @user, :bypass => true
        redirect_to root_path
      else
        respond_to do |format|
          format.html { render 'devise/user_profile'}
          format.json { render json: [@user.errors], status: :unprocessable_entity }
        end
      end
  end

  def sign_with_social
    token = params[:token]
    if !token.nil?
      require 'net/http'
      url = URI.parse('http://ulogin.ru/token.php?token='+token)
      social_data = ActiveSupport::JSON.decode(Net::HTTP.get(url))
      uid = social_data['identity']
      email = social_data['email']
      first_name = social_data['first_name']
      last_name = social_data['last_name']
      @user = User.find_by_email(email)
      if @user.nil?
        @user = User.find_by_authentication_token(uid)
        my_time = Time.now
        if @user.nil?
          @user = User.new
          @user.email=email
          @user.password="password"
          @user.authentication_token=uid
          @user.first_name=first_name
          @user.last_name=last_name
          @user.skip_confirmation!
          @user.save
        end
      end
      sign_in @user, :bypass => true
      redirect_to root_path
    end
  end
end
