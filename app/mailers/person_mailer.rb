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
    @internship = internship
    emails = [internship.host.email, internship.intern.email]

    mail(to: emails, subject: "You have an intern now!")
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
