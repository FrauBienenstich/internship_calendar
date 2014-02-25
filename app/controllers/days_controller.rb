class DaysController < ApplicationController
  def index
    @days = Day.all
  end

  def show
    @day = Day.find(params[:id])
  end

  def current
    @day = Day.last
    puts Day.count
    render :show
  end
end
