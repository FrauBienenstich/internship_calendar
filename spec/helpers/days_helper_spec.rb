require 'spec_helper'

describe DaysHelper do
  before do
    @day = FactoryGirl.create(:day)
  end

  describe '#remaining_time_in_words(day)' do
    it 'formats a past date' do
      @day.date = 1.day.ago
      formatted_string = remaining_time_in_words(@day)
      expect(formatted_string).to match "ago"
    end

    it 'formats a future date' do
      @day.date = 1.day.from_now
      formatted_string = remaining_time_in_words(@day)
      expect(formatted_string).to match "remaining"
    end

    it 'formats today' do
      @day.date = Time.zone.now
      formatted_string = remaining_time_in_words(@day)
      expect(formatted_string).to eql "Today!"
    end

    it 'handles bogus data' do
      results = []
      [nil, 5, 0, "huhu", 3.9, {foo: "bar"}, [1,2,3]].each do |bogus|
         results << remaining_time_in_words(bogus)
      end
      results = results.uniq
      expect(results.length).to eql 1
      expect(results[0]).to match "Invalid time"
    end

  end

  describe '#relative_date_in_words' do

    it 'formats a past date' do
      @day.date = 1.day.ago
      formatted_string = relative_date_in_words(@day)
      expect(formatted_string).to match "ago"
    end

    it 'formats a future date' do
      @day.date = 1.day.from_now
      formatted_string = relative_date_in_words(@day)
      expect(formatted_string).to match "in"
    end

    it 'formats today' do
      @day.date = Time.zone.now
      formatted_string = relative_date_in_words(@day)
      expect(formatted_string).to eql "Today!"
    end

    it 'handles bogus data' do
      results = []
      [nil, 5, 0, "huhu", 3.9, {foo: "bar"}, [1,2,3]].each do |bogus|
         results << relative_date_in_words(bogus)
      end
      results = results.uniq
      expect(results.length).to eql 1
      expect(results[0]).to match "Invalid time"
    end
  end
  
end