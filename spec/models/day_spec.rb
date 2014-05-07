require 'spec_helper'

describe Day do

  describe 'scopes' do

    before do
      @future_day = FactoryGirl.create(:day, date: "2200-05-14")
      @past_day = FactoryGirl.create(:day, date: "2014-01-01")
    end

    it 'returns days that are today or in the future' do
      expect(Day.future).to eq [@future_day]
    end

    it "returns days that are in the past" do
      expect(Day.past).to eq [@past_day]
    end
  end

  describe 'self.upcoming_day' do

    before do
      @future_day = FactoryGirl.create(:day, date: "2200-05-14")
      @future_day_2 = FactoryGirl.create(:day, date: "2222-10-12")
    end

    it 'returns the next future day' do
      expect(Day.upcoming_day).to eq @future_day
    end
  end

  describe '#open_internships' do

    before do
      @day = FactoryGirl.create(:day)
      @internship_1 = FactoryGirl.create(:internship, day: @day, intern_id: nil)
      @internship_2 = FactoryGirl.create(:internship, day: @day,  intern_id: 5)
      @internship_3 = FactoryGirl.create(:internship, day: @day,  intern_id: nil)
    end

    it 'returns number of internships that have no intern' do
      expect(@day.open_internships).to eq 2
    end
  end

  describe '#occupied_internships' do

    before do
      @day = FactoryGirl.create(:day)
      @internship_1 = FactoryGirl.create(:internship, day: @day,  intern_id: nil)
      @internship_2 = FactoryGirl.create(:internship, day: @day,  intern_id: 5)
      @internship_3 = FactoryGirl.create(:internship, day: @day,  intern_id: nil)
    end

    it 'returns the number of internships that are taken already' do
      expect(@day.occupied_internships).to eq 1
    end
  end

  describe '# no_internships?' do
    before do
      @day = FactoryGirl.create(:day)
      @day.internships = []
    end

    it 'returns true if a day has no internships' do
      expect(@day.no_internships?).to be_true      
    end
  end

  describe '#no_interns?' do

    it 'returns true if a day has no interns yet' do
      @day = FactoryGirl.create(:day)
      @internship_1 = FactoryGirl.create(:internship, day: @day)
      @internship_2 = FactoryGirl.create(:internship, day: @day)
      @internship_1.intern = nil
      @internship_2.intern = nil

      expect(@day.no_interns?).to be_true
    end

    it 'returns false if a day has interns' do
      @day = FactoryGirl.create(:day)
      @internship_1 = FactoryGirl.create(:internship, day: @day, intern: nil)
      @internship_2 = FactoryGirl.create(:internship, day: @day, intern: FactoryGirl.create(:intern))

      expect(@day.no_interns?).to be_false
    end
  end
end