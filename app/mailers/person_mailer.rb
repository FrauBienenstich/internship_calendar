class PersonMailer < ActionMailer::Base
  default from: "openday@nugg.ad" # APP_CONFIG[:mail_from] oder sowas, more generic?

  def confirmation_mail(person, time)
    @person = person
    @time = time
    # @url = current_days_path

    mail(to: @person.email, subject: "You successfully created an open internship")
  end
end
