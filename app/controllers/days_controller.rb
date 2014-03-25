class DaysController < ApplicationController
  def index
    @days = Day.all
  end

  def show
    @day = Day.find(params[:id])
    @internships = @day.internships
  end

  def current
    @day = Day.last
    render :show
  end
end
