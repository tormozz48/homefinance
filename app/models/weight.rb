class Weight < ActiveRecord::Base
  paginates_per 30

  validates :enabled, :weight, :date, :presence => true
  validates :weight, :numericality => {:greater_than_or_equal_to => 0 }
  validate :enabled, :training => { :in => [true, false] }
  validates :date, :uniqueness => {:scope => [:user_id, :enabled]}

  belongs_to :user, :readonly => true
  has_many :eatings

  def day_difference
     rec = Weight.find_by_user_id_and_date_and_enabled(self.user_id, self.date.yesterday, true)
     if(rec.nil?)
        return 0
     else
        return self.weight - rec.weight
     end
  end

  def week_difference
    rec = Weight.find_by_user_id_and_date_and_enabled(self.user_id, self.date.weeks_ago(1), true)
    if(rec.nil?)
      return 0
    else
      return self.weight - rec.weight
    end
  end

  def month_difference
    rec = Weight.find_by_user_id_and_date_and_enabled(self.user_id, self.date.months_ago(1), true)
    if(rec.nil?)
      return 0
    else
      return self.weight - rec.weight
    end
  end

  def get_eatings
    return self.eatings
  end

end
