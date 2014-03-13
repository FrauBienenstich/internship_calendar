class Slot < ActiveRecord::Base

  belongs_to :day
  has_many :internships

  def get_time
    "#{start_time.strftime("%H:%M")} until #{end_time.strftime("%H:%M")}"
  end
end
