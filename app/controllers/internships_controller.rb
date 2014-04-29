class InternshipsController < ApplicationController


  respond_to :html

  def create

    host = Person.find_or_new(params[:email], params[:name])

    internship = Internship.new(:description => params[:description], 
                                :day_id => params[:day_id],
                                :host => host,
                                :start_time => params[:internship][:start_time],
                                :end_time => params[:internship][:end_time])

    if host && host.save && internship && internship.save
      PersonMailer.confirmation_mail(internship).deliver
      redirect_to day_path(internship.day), notice: "You successfully created an internship!"
      puts "when saved #{internship.inspect}"
    else  
      day = Day.find_by_id(params[:day_id])
      url = day ? day_path(day) : days_path
      redirect_to url, :flash => { :error => "Your internship could not be saved: #{internship.errors.full_messages.join(', ')} #{host.errors.full_messages.join(', ')}" }
    end
  end

  def new
    @day = Day.find_by(id: params[:day_id])

    @internship = Internship.new
    render :layout => false
  end

  def sign_up_form
    @internship = Internship.find_by(id: params[:id])
    render :layout => false
  end

  def update
    @internship = Internship.find_by(id: params[:id])
    if params[:commit] == "Remove"
      if @internship.delete_intern!
        flash[:notice] = "Worked"
      else
        flash[:error] = "Did not work"
      end
    else
      
      if @internship.assign_intern(params[:email], params[:name])
        flash[:notice] = "You successfully became an intern."
        PersonMailer.assign_intern_mail(@internship).deliver
        PersonMailer.confirmation_for_intern_mail(@internship).deliver
      else
        flash[:error] = "Your application as an intern failed! #{@internship.errors.full_messages.join(', ')}"
      end
    end
    redirect_to day_path(@internship.day)
  end
  

  def edit
    @internship = Internship.find_by(id: params[:id])
    render :layout => false
  end

  def destroy
    @internship = Internship.find(params[:id])

    @internship.destroy

    PersonMailer.delete_internship_mail(@internship).deliver
    redirect_to day_path(@internship.day), notice: "You successfully deleted an internship"
  end

end



# {
#   "utf8"=>"✓",
#   "authenticity_token"=>"FAUpvGQeq4SkgrlQU2lIXP2CdzEaattm4/t29xDGDt0=",
#   "internship"=> {
#     "description"=>"wawawa",
#     "ende" => "morgen"
#   },
#   "commit"=>"Create Internship",
#   "action"=>"create", 
#   "controller"=>"internships"
# }