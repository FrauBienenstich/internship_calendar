require "spec_helper"

describe PersonMailer do


  it 'sends out a confirmation mail' do
    internship = FactoryGirl.create(:internship) # build oder expect?

    mailer = described_class.confirmation_mail(internship)
    expect do
      mailer.deliver
    end.to change { ActionMailer::Base.deliveries.size }.by(1)

    mail = ActionMailer::Base.deliveries.last
    expect(mail.subject).to eql "You successfully created an open internship"
    expect(mail.from).to eql ["openday@nugg.ad"]
    expect(mail.to).to eql [internship.host.email]
  end


  it 'sends out an email if an intern is deleted from an internship' do
    internship = FactoryGirl.create(:internship)
    internship.create_intern( FactoryGirl.attributes_for(:intern) )

    deleted_intern = internship.intern

    mailer = described_class.delete_intern_mail(internship, deleted_intern)

    expect do
      mailer.deliver
    end.to change { ActionMailer::Base.deliveries.size }.by(1)

    mail = ActionMailer::Base.deliveries.last
    expect(mail.subject).to eql "Intern was deleted"
    expect(mail.from).to eql ["openday@nugg.ad"]
    expect(mail.to).to eql [internship.host.email, deleted_intern.email]

  end
  

end
