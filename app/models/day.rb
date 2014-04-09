class Day < ActiveRecord::Base
  has_many :internships
  validates_presence_of :date
  validates_uniqueness_of :date

  def upcoming_day
    date > Date.today or date == Date.today
  end
end

