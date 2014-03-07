class PersonMailer < ActionMailer::Base
  default from: "openday@nugg.ad"

  def confirmation_mail(internship)
    @person = internship.host
    @time = internship.slot.name
    @day = internship.slot.day

    @description = internship.description

    mail(to: @person.email, subject: "You successfully created an open internship")
  end

  def delete_intern_mail(internship, deleted_intern)
    @internship = internship
    @deleted_intern = deleted_intern
    emails = [@internship.host.email, deleted_intern.email]

    mail(to: emails, subject: "Intern was deleted")
  end

  def assign_intern_mail(internship)
    @host = internship.host
    @intern = internship.intern
    @time = internship.slot.name
    @day = internship.slot.day
    @description = internship.description
    emails = [@host.email, @intern.email]

    mail(to: emails, subject: "You have an intern now!")
  end

  def delete_internship_mail(internship)
    @host = internship.host
    @intern = internship.intern
    @time = internship.slot.name
    @day = internship.slot.day
    @description = internship.description

    if @intern
      emails = [@host.email, @intern.email]
    else
      emails = @host.email
    end

    mail(to: emails, subject: "Internship was deleted")
  end
end
