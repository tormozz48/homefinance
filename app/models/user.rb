class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         :lockable,
         :timeoutable,
         :omniauthable


  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  attr_accessible :nickname, :provider, :url, :username, :authentication_token

  def self.find_for_facebook_oauth access_token
    logger.info "find for facebook start"
    if user = User.where(:url => access_token.info.urls.Facebook).first
      logger.info "user found by facebook token id"
      return user
    elsif
      user = User.where(:email => access_token.extra.raw_info.email)
      logger.info "user found by email"
      return user
    else
      logger.info "start create user"
      user = User.new(:provider => access_token.provider,
                      :url => access_token.info.urls.Facebook,
                      :username => access_token.extra.raw_info.name,
                      :nickname => access_token.extra.raw_info.username,
                      :email => access_token.extra.raw_info.email,
                      :password => Devise.friendly_token[0,20])
      user.skip_confirmation!
      user.errors.full_messages.each do |msg|
        logger.info msg
      end

      user.save!
      logger.info "user saved to db"
      return user
    end
  end
end
