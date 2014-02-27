class Person < ActiveRecord::Base

  validates :email, uniqueness: true
  has_many :lectureships, :class_name => "Internship"
  has_many :internships, :class_name => "Internship"
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }


end
