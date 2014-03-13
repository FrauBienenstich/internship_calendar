class Internship < ActiveRecord::Base

  validates :host, presence: true
  validates :slot_id, presence: true
  validates :description, presence: true

  belongs_to :slot
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

  def assign_intern(email)

    self.intern = Person.find_or_initialize_by(:email => email) # not yet saved!
    save

    ical = to_ical
    #puts ical.inspect

    #puts "SELF #{self}"
    PersonMailer.assign_intern_mail(self, ical).deliver
    PersonMailer.confirmation_for_intern_mail(self, ical).deliver

    #self.intern.name = params[:name]
    
   # if @internship.intern.save && @internship.save
  #     flash[:notice] = "You successfully became an intern!"
     # PersonMailer.assign_intern_mail(@internship).deliver

    #else
  #     flash[:error] = "Your application as an intern failed!"
    #   false
    # end
  end

  def to_ical
    @calendar = Icalendar::Calendar.new
    event = Icalendar::Event.new
    start_time = 1.day.from_now
    end_time = start_time + 1.hour

    event.start = start_time.strftime("%Y%m%dT%H%M%S")
    event.end = end_time.strftime("%Y%m%dT%H%M%S")
    event.summary = description
    event.description = description
    event.location = "nugg.ad office"
    @calendar.add event
    @calendar.publish
    # headers['Content-Type'] = "text/calendar; charset=UTF-8"
    @calendar.to_ical
  end


end
