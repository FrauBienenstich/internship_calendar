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
  

end
