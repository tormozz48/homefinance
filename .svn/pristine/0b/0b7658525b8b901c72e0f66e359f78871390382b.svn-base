class Category < ActiveRecord::Base
  validates :name, :color, :amount, :presence => true
  validates :amount, :numericality => {:greater_than_or_equal_to => 0 }
  validates :name, :length => {:minimum => 5, :maximum => 30}
  validates :description, :length => {:maximum => 255}
  validates :color, :length => {:is => 6}
  validates :name, :uniqueness => {:scope => :user_id}

  belongs_to :user, :readonly => true
end
