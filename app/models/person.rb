class Person < ActiveRecord::Base

  validates :email, uniqueness: true
  validates :email, presence: true
  validates :name, presence: true
  has_many :lectureships, :class_name => "Internship"
  has_many :internships, :class_name => "Internship"
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }

  def self.find_or_new(email, name)
    person = Person.find_or_initialize_by(:email => email)
    person.name = name
    person
  end

end
