require "spec_helper"

describe PersonMailer do


  describe '#confirmation_mail' do
    it 'sends out an email if internship was registered' do
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


  describe '#delete_intern_mail' do
    it 'sends out an email if intern was deleted' do
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

  describe '#assign_intern_mail' do
    it 'sends out an email if intern was assigned' do
      internship = FactoryGirl.create(:internship)
      internship.create_intern( FactoryGirl.attributes_for(:intern))

      mailer = described_class.assign_intern_mail(internship)

      mailer.deliver
      mail = ActionMailer::Base.deliveries.last
      expect(ActionMailer::Base.deliveries.size).to eql 1
      expect(mail.subject).to eql "You have an intern now!"
      expect(mail.from).to eql ["openday@nugg.ad"]
      expect(mail.to).to eql [internship.host.email, internship.intern.email]
    end
  end

  describe '#delete_internship_mail' do
    context "if intern present" do
      it "sends out an email if internship is deleted" do
        internship = FactoryGirl.create(:internship)
        internship.create_intern(FactoryGirl.attributes_for(:intern))

        mailer = described_class.delete_internship_mail(internship)
        mailer.deliver
        mail = ActionMailer::Base.deliveries.last

        expect(ActionMailer::Base.deliveries.size).to eql 1
        expect(mail.subject).to eql "Internship was deleted"
        expect(mail.from).to eql ["openday@nugg.ad"]

        expect(mail.to).to eql [internship.host.email, internship.intern.email]
      end
    end
    
    context "if no intern present" do
      it "sends out an email if internship is deleted" do
        internship = FactoryGirl.create(:internship)
        mailer = described_class.delete_internship_mail(internship)
        mailer.deliver
        mail = ActionMailer::Base.deliveries.last

        expect(ActionMailer::Base.deliveries.size).to eql 1
        expect(mail.subject).to eql "Internship was deleted"
        expect(mail.from).to eql ["openday@nugg.ad"]

        expect(mail.to).to eql [internship.host.email]
      end
    end
  end
end
