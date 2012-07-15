class Category < ActiveRecord::Base
  validates :name, :color, :amount, :enabled, :presence => true
  validates :amount, :numericality => {:greater_than_or_equal_to => 0 }
  validates :name, :length => {:minimum => 3, :maximum => 30}
  validates :description, :length => {:maximum => 255}
  validates :color, :length => {:is => 6}
  validates :name, :uniqueness => {:scope => [:user_id, :enabled]}
  validate :name, :reserve_name
  validate :enabled, :inclusion => { :in => [true, false] }

  belongs_to :user, :readonly => true

  attr_accessible :name, :amount, :description, :color, :user, :user_id, :enabled

  def reserve_name
    errors.add(:name, I18n.t('message.error.category.reserved')) if [I18n.t('common.undefined')].include? self.name
  end

end
