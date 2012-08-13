class UsersController < ApplicationController
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

  def social_authentification
     token = params[:token]
     app_id = "30025"
     secret_key = "8374210538983a539635429893ff2584"
     if !token.nil?
       require 'net/http'
       url = URI.parse('http://loginza.ru/api/authinfo?token='+token+"&id="+app_id+"&sig="+secret_key)
       social_data = ActiveSupport::JSON.decode(Net::HTTP.get(url))
       identity = social_data['identity']
       provider = social_data['provider']
       nickname = social_data['nickname']
       email = social_data['email']
     end
     redirect_to root_path
  end
end
