class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :timeoutable

  validates :email, :presence => true
  validates :email, :length => {:maximum => 255}

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  attr_accessible :nickname, :provider, :url, :username, :authentication_token
  attr_readonly :id, :created_at, :updated_at
end
