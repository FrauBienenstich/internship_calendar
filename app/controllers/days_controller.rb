class DaysController < ApplicationController
  def index
    @days = Day.all
    @start_page = true
  end

  def create

    date = Date.new(params["day"]["date(1i)"].to_i, params["day"]["date(2i)"].to_i, params["day"]["date(3i)"].to_i)

    @day = Day.new(date: date)

    if @day.save
      redirect_to days_path, notice: "You created a new internship day!"
    else
      redirect_to days_path, :flash => { :error => "Your new day could not be saved"}
    end
  end

  def new
    @day = Day.new
    render :layout => false
  end

  def show
    @day = Day.find(params[:id])
    @internships = @day.internships.order('start_time ASC')
  end

  def destroy
    @day = Day.find(params[:id])

    @day.destroy
    redirect_to days_path, notice: "You just deleted an internship day"
  end
end
