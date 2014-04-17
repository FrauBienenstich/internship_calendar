class Day < ActiveRecord::Base
  has_many :internships
  validates_presence_of :date
  validates_uniqueness_of :date

  scope :future, -> { where("date >= ?", Date.today.to_s(:db)) }
  scope :past, -> { where("date < ?", Date.today.to_s(:db)) }

  # def self.future
  #   where(:date < Date.today)
  # end

  # def self.past
  #   date < Date.today
  # end

  def self.upcoming_day
    future.order("date ASC").first
  end

  def open_internships
    internships.where(intern_id: nil).count
  end

end

