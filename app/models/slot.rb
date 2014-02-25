class Slot < ActiveRecord::Base

  belongs_to :day
  has_many :internships
end
