class PersonMailer < ActionMailer::Base
  default from: "openday@nugg.ad"

  def confirmation_mail(person, time, day, description)
    @person = person
    @time = time
    @day = day
    @description = description

    mail(to: @person.email, subject: "You successfully created an open internship")
  end

  def update_mail(host, intern, time, day, description)
    @host = host
    @intern = intern
    @time = time
    @day = day
    @description = description
    emails = [@host.email, @intern.email]

    mail(to: emails, subject: "Internship was updated!")
  end
end
