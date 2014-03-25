class InternshipsController < ApplicationController
  respond_to :html

  def create
    host = Person.find_or_initialize_by(email: params[:email])
    host.name = params[:name] if host
    puts "PARAMS #{params}"
    #PARAMS {"utf8"=>"✓", "authenticity_token"=>"FAUpvGQeq4SkgrlQU2lIXP2CdzEaattm4/t29xDGDt0=", "day_id"=>"1", "description"=>"Tolle Sache!!!", "email"=>"susanne.dewein@gmail.com", "name"=>"Susi", "hour"=>"10", "minute"=>"30", "meridian"=>"PM", "action"=>"create", "controller"=>"internships"}

    
    internship = Internship.new(:description => params[:description], 
                                :day_id => params[:day_id],
                                :host => host,
                                :start_time => params[:start_time],
                                :end_time => params[:end_time])


    if host && host.save && internship && internship.save
      ical = internship.to_ical # NOTE TO MYSELF: this has to be called after save!!! before i had a red test
      PersonMailer.confirmation_mail(internship, ical).deliver
      redirect_to day_path(internship.day), notice: "You successfully created an internship!"

    else
      redirect_to days_path, :flash => { :error => "Your internship could not be saved: #{internship.errors.full_messages.join(', ')} #{host.errors.full_messages.join(', ')}" }
    end
  end

  def new
    puts params
    #@slot = Slot.find_by(id: params[:slot_id])
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
      @internship.assign_intern(params[:email], params[:name])
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