class Weight < ActiveRecord::Base
  validates :enabled, :weight, :date, :presence => true
  validates :weight, :numericality => {:greater_than_or_equal_to => 0 }
  validate :enabled, :training => { :in => [true, false] }
  validates :date, :uniqueness => {:scope => [:user_id, :enabled]}

  belongs_to :user, :readonly => true
  has_many :eatings

  def day_difference
     rec = Weight.find_all_by_user_id_and_date(self.user_id, 1.day.ago.to_date).first()
     if(rec.nil?)
        return self.weight
     else
        return self.weight - rec.weight
     end
  end

  def week_difference
    rec = Weight.find_all_by_user_id_and_date(self.user_id, 1.day.ago.to_date).first()
    if(rec.nil?)
      return self.weight
    else
      return self.weight - rec.weight
    end
  end

  def month_difference
    rec = Weight.find_all_by_user_id_and_date(self.user_id, 1.day.ago.to_date).first()
    if(rec.nil?)
      return self.weight
    else
      return self.weight - rec.weight
    end
  end

end
