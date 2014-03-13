require 'spec_helper'

describe Internship do

  # it { should belong_to :slot } nono

  describe '#delete_intern' do

    before do
      @internship = FactoryGirl.create(:internship)
      @intern = FactoryGirl.create(:intern)
      @internship.update_attributes(:intern => @intern)
    end

    it 'sets the intern_id in an internship to nil' do
      @internship.delete_intern!

      expect(@internship.reload.intern_id).to eql nil
    end

    it 'sends an email if intern was deleted' do
      PersonMailer.any_instance.should_receive(:delete_intern_mail).with(@internship, @intern)

      @internship.delete_intern!
    end
  end

  describe '#assign_intern' do
    
    before do
      @internship = FactoryGirl.create(:internship)
      @ical = Icalendar::Calendar.new.to_ical
    end 

    it 'finds an exisiting person as an intern for an internship' do
      @person = FactoryGirl.create(:person, :email => "susanne.dewein@gmail.com")
      expect {
        @internship.assign_intern("susanne.dewein@gmail.com")
        expect(@internship.reload.intern).to eql @person
      }.not_to change{ Person.count }
    end

    it 'creates a new person as an intern for an internship' do
      expect(@internship.intern).to eql nil
      
      expect {
        @internship.assign_intern("susanne.dewein@gmail.com")
        expect(@internship.reload.intern.email).to eql "susanne.dewein@gmail.com"
      }.to change{Person.count}.by 1
    end

    it 'sends out an email to host when intern saved' do
      PersonMailer.any_instance.should_receive(:assign_intern_mail)
      @internship.assign_intern("susanne.dewein@gmail.com")
    end

    # it 'sends out an email to the intern when they assign themselves' do
    #   ical = @internship.to_ical
    #   PersonMailer.any_instance.should_receive(:confirmation_for_intern_mail).with(@internship, ical)
    #   @internship.assign_intern("susanne.dewein@gmail.com")
    # end
  end
end
