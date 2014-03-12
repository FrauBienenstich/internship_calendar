require 'spec_helper'

describe Internship do

  # it { should belong_to :slot } nono

  describe '#delete_intern' do

    before do
      @internship = FactoryGirl.create(:internship)
      @internship.intern = FactoryGirl.create(:intern)
      @deleted_intern = @internship.intern
    end

    it 'sets the intern_id in an internship to nil' do
      @internship.delete_intern
      expect(@internship.intern_id).to eql nil
    end

    it 'sends an email if intern was deleted' do
      @internship.delete_intern

      mailer = PersonMailer.delete_intern_mail(@internship, @deleted_intern)

      expect do
        mailer.deliver
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
      #PersonMailer.any_instance.should_receive(:delete_intern_mail).with(@internship, @deleted_intern)
      # why does other expression not work? and: i already tested this in person_mailer_spec...where does it actually belong?
    end
  end

  describe '#assign_intern' do
    
  end
end
