require 'spec_helper'

describe Day do

  describe '#upcoming_day' do
    before do
      @day = FactoryGirl.create(:day)
    end


    it 'returns false if day is not today and not in the future' do
      @day.upcoming_day
      expect(@day.upcoming_day).to be_false
    end
  end
  
end