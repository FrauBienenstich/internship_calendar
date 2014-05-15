class InternshipsController < ApplicationController

  respond_to :html, :js

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
    puts "PARAMS #{params}"
    @internship = Internship.find_by(id: params[:id])
    host = Person.find_by_email(params[:email])
    #puts "internship_params #{internship_params}" contains only start_time and end_time, HOW DOES STRONG PARAMETERS WORK WITH MY WEIRD HASH??? and why is it weird?

    @internship.update(:description => params[:description], 
                                :day_id => params[:day_id],
                                :host => host,
                                :start_time => params[:internship][:start_time],
                                :end_time => params[:internship][:end_time]) # actuallly this should be sth like internship_params

    respond_with(@internship) do |format|
      format.html { redirect_to day_path(@internship.day), notice: 'Internship was successfully updated!' }
      format.js
    end
  end

  def update_intern
    @internship = Internship.find_by(id: params[:id])

    new_intern = false if @internship.intern

    if params[:commit] == "Remove"
      if @internship.delete_intern!
        flash[:notice] = "Worked"
      else
        flash[:error] = "Did not work"
      end
    else
      if @internship.assign_intern(params[:email], params[:name]) and new_intern
        flash[:notice] = "You successfully became an intern."
        PersonMailer.assign_intern_mail(@internship).deliver
        PersonMailer.confirmation_for_intern_mail(@internship).deliver
      elsif @internship.assign_intern(params[:email], params[:name]) and new_intern == false
        flash[:notice] = "You successfully updated your position as an intern!"
      #TODO schöner machen
      else
        flash[:error] = "Your application as an intern failed! #{@internship.errors.full_messages.join(', ')}"
      end  
    end

    respond_with(@internship) do |format|
      format.html { redirect_to day_path(@internship.day) }
      format.js { render :action => "update" }
    end
  end
  

  def edit_intern
    @internship = Internship.find_by(id: params[:id])
    render :layout => false
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

  private

  # def internship_params
  #   params.require(:internship).permit(:host, :intern, :description, :start_time, :end_time, :day_id)
  # end

  # def intern_params
  #   params.require(:intern).permit(:name, :email)
  # end

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