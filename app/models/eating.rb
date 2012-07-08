class Eating < ActiveRecord::Base
  validates :enabled, :time, :food, :eating_type_id, :presence => true
  validate :enabled, :overweight => { :in => [true, false] }
  validates :food, :length => {:maximum => 255}

  belongs_to :weight, :readonly => true
  belongs_to :eating_type, :readonly => true

  attr_accessible :enabled, :time, :eating_type_id, :overweight, :food, :weight_id
end
