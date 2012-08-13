class UsersController < Devise::OmniauthCallbacksController
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

  def facebook
    @user = User.find_for_facebook_oauth request.env["omniauth.auth"]
    if @user.nil? == false
      logger.info "user found in database"
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      logger.info "user sign in start"
      sign_in @user, :bypass => true
      logger.info "user sign in end"
      redirect_to root_path
    end
  end

  def vkontakte
  end
end
