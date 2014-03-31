class Internship < ActiveRecord::Base

  validates :host, presence: true
  validates :day_id, presence: true
  validates :description, presence: true

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

    self.intern = Person.find_or_initialize_by(:email => email, :name => name) # not yet saved!
    self.intern.save
    self.save

    puts "INTERN #{self.intern.inspect}"
    puts "Internship #{self.inspect}"

    ical = to_ical

    PersonMailer.assign_intern_mail(self, ical).deliver
    PersonMailer.confirmation_for_intern_mail(self, ical).deliver

   #  self.intern.name = params[:name]
    
   # if self.intern.save && @internship.save
   #    flash[:notice] = "You successfully became an intern!"
   #   PersonMailer.assign_intern_mail(@internship).deliver

   #  else
   #    flash[:error] = "Your application as an intern failed!"
   #    false
   #  end
  end

  def get_timeslot
    "#{self.start_time} until #{self.end_time}"
    "#{self.start_time.to_time_of_day} until #{self.end_time.to_time_of_day}"
  end

  def different_day
    "#{start_time.strftime("%B %d, %Y")}" if start_time > day.date
  end

  def to_ical
    @calendar = Icalendar::Calendar.new
    event = Icalendar::Event.new
    event.start = start_time
    event.end = end_time
    event.summary = description
    event.description = description
    event.location = "nugg.ad office"
    @calendar.add event
    @calendar.publish
    # headers['Content-Type'] = "text/calendar; charset=UTF-8"
    @calendar.to_ical
  end


end
