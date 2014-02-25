class Person < ActiveRecord::Base

  has_many :lectureships, :class_name => "Internship"
  has_many :internships, :class_name => "Internship"

end
