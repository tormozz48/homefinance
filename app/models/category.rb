class Category < ActiveRecord::Base
  validates :name, :presence => true
  validates :color, :presence => true
  validates :amount, :presence => true
  validates :enabled, :presence => true
  validates :user_id, :presence => true

  validates :amount, :numericality => {:only_integer => false,
                                       :greater_than_or_equal_to => 0 }
  validates :user_id, :numericality => {:only_integer => true,
                                        :greater_than_or_equal_to => 0 }

  validates :name, :length => {:minimum => 3, :maximum => 30}
  validates :description, :length => {:maximum => 255}
  validates :color, :length => {:is => 6}
  validates :name, :uniqueness => {:scope => [:user_id, :enabled]}
  validate :name, :reserve_name
  validate :enabled, :inclusion => { :in => [true, false] }

  belongs_to :user, :readonly => true

  attr_accessible :name, :amount, :description, :color, :user, :user_id, :enabled
  attr_readonly :id, :created_at, :updated_at

  scope :order_by_name, -> { order(:name) }
  scope :enabled, -> { where('enabled = true')}

  def reserve_name
    errors.add(:name, I18n.t('message.error.category.reserved')) if [I18n.t('common.undefined')].include? self.name
  end

end
