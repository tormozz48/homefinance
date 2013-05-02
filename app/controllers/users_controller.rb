class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :update]

  def edit
    @user = current_user
    respond_to do |format|
      format.html {render 'devise/user_profile'}
    end
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_without_password(params[:user])
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
     app_id = '30025'
     secret_key = '8374210538983a539635429893ff2584'
     unless token.nil?
       social_data = Loginza.user_data(token,
                                       :options => {:id => app_id, :sig => secret_key})
       email = social_data['email']
       logger.info(email)
       unless email.nil?
          user = User.find_by_email(email)
          unless user.nil?
            user = User.new(:email => email,
                            :provider => social_data['provider'],
                            :first_name => social_data['name']['first_name'],
                            :last_name => social_data['name']['last_name'],
                            :nickname => social_data['nickname'],
                            :authentication_token => social_data['uid'],
                            :password => secret_key)
            user.skip_confirmation!
            user.save
          end
          sign_in user, :bypass => true
       end
     end
     redirect_to root_path
  end
end
