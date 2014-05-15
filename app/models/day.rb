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

  #NB: scopes sind Klassenmethode!!

  def self.upcoming_day
    future.order("date ASC").first
  end

  def open_internships
    internships.where(intern_id: nil).count
  end

  def occupied_internships
    internships.count - open_internships
  end

  def no_internships?
    true if internships.count == 0
  end

  def no_interns?
    open_internships == internships.count
  end

end

