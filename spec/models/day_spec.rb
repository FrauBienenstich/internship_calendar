require 'spec_helper'

describe Day do

  describe '#upcoming_day' do
    before do
      @day = FactoryGirl.create(:day)
    end


    it 'returns false if day is not today and not in the future' do
      expect(@day.upcoming_day).to be_true
    end
  end
  
end