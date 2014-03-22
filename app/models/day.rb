class Day < ActiveRecord::Base
  has_many :slots

  def upcoming_day
    self.date > Date.today or self.date == Date.today
  end
end

