class PersonMailer < ActionMailer::Base
  default from: "openday@nugg.ad"

  def confirmation_mail(internship, ical)
    @person = internship.host
    @time = internship.slot.name
    @day = internship.slot.day

    @description = internship.description

    attachments["internship_appointment.ics"] = {content_type: "text/calendar; charset=UTF-8", content: ical}

    mail(to: @person.email, subject: "You successfully created an open internship")
  end

  def delete_intern_mail(internship, deleted_intern)
    @internship = internship
    @deleted_intern = deleted_intern
    emails = [@internship.host.email, @deleted_intern.email]

    mail(to: emails, subject: "Intern was deleted")
  end

  def assign_intern_mail(internship, ical)
    @internship = internship
    mail(to: @internship.host.email, subject: "You have an intern now!")
  end

  def confirmation_for_intern_mail(internship, ical)
    @internship = internship
    attachments["internship_appointment.ics"] = {content_type: "text/calendar; charset=UTF-8", content: ical}
    mail(to: @internship.intern.email, subject: "You are interning with #{@internship.host.name}!")
  end

  def delete_internship_mail(internship)
    @internship = internship

    if @internship.intern
      emails = [@internship.host.email, @internship.intern.email]
    else
      emails = @internship.host.email
    end

    mail(to: emails, subject: "Internship was deleted")
  end
end
