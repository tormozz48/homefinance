class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :timeoutable

  validates :email, :presence => true
  validates :email, :length => {:maximum => 255}

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  attr_accessible :nickname, :provider, :url, :username, :authentication_token

  attr_accessible :encrypted_password, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip
  attr_accessible :last_sign_in_ip, :confirmed_at, :confirmation_sent_at, :failed_attempts

  attr_readonly :id, :created_at, :updated_at

  def full_name
    if  !first_name.nil? && !last_name.nil?
      "#{first_name} #{last_name}"
    else
      email
    end
  end
end
