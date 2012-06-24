class EatingType < ActiveRecord::Base
  validates :enabled, :name, :eating_order, :presence => true
  validates :name, :length => {:minimum => 3, :maximum => 30}
  validates :eating_order, :numericality => {:greater_than_or_equal_to => 0 }
  validate :enabled, :inclusion => { :in => [true, false] }
end
