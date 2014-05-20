class DaysController < ApplicationController
  
  def welcome
    @start_page = true
    @upcoming_day = Day.upcoming_day
  end

  def index
    if params.has_key? :past
      @days = Day.past
    elsif params.has_key? :future
      @days = Day.future
    else
      @days = Day.all
    end

    @days = @days.order("date ASC")
  end

  def create
    @day = nil
    begin
      @day = Day.new(date: params[:day][:date])
    rescue
    end

    if @day && @day.save
      flash[:notice] = "You created a new internship day!"
    else
      flash[:error] = "Your new day could not be saved"
    end
    redirect_to days_path
  end

  def new
    @day = Day.new
    render :layout => true
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
