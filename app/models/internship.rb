class Internship < ActiveRecord::Base

  validates :host, presence: true
  validates :day_id, presence: true
  validates :description, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  belongs_to :day
  belongs_to :host, :class_name => "Person"
  belongs_to :intern, :class_name => "Person"



  def delete_intern!
    deleted_intern = self.intern
    self.intern_id = nil

    if save
      PersonMailer.delete_intern_mail(self, deleted_intern).deliver
    else 
      false
    end
  end

  def assign_intern(email, name)

    self.intern = Person.find_or_new(email, name)

    self.intern.save && self.save
  end

  def get_timeslot
    "#{self.start_time.to_time_of_day.strftime("%H:%M")} until #{self.end_time.to_time_of_day.strftime("%H:%M")}"
  end

  def different_day
    "#{start_time.strftime("%B %d, %Y")}" if start_time.to_date != day.date
  end

  def to_ical
    @calendar = Icalendar::Calendar.new
    event = Icalendar::Event.new
    event.dtstart = start_time.to_datetime
    event.dtend = end_time.to_datetime
    event.summary = description
    event.description = description
    event.location = "nugg.ad office"
    @calendar.add event
    @calendar.publish
    # headers['Content-Type'] = "text/calendar; charset=UTF-8"
    @calendar.to_ical
  end
end