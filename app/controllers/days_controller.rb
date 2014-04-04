class DaysController < ApplicationController
  def index
    @days = Day.all
    @start_page = true
  end

  def show
    @day = Day.find(params[:id])
    @internships = @day.internships.order('start_time ASC')
  end
end
