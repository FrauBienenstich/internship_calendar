class DaysController < ApplicationController
  def index
    @days = Day.all
    @start_page = true
  end

  def create
    puts "PARAMZZZ #{params}"

    @day = Day.new(date: params[:day][:date])

    if @day.save
      flash[:notice] = "You created a new internship day!"
    else
      flash[:error] = "Your new day could not be saved"
    end
    redirect_to days_path
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
