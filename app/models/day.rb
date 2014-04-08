class Day < ActiveRecord::Base
  has_many :internships

  def upcoming_day
    date > Date.today or date == Date.today
  end
end

