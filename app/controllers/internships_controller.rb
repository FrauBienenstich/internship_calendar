class InternshipsController < ApplicationController

  respond_to :html, :js

  def create
    host = Person.find_or_new(params[:host][:email], params[:host][:name])

    internship_attr = params[:internship].merge(:host => host)

    internship = Internship.new(internship_attr)

    if host && host.save && internship && internship.save
      PersonMailer.confirmation_mail(internship).deliver
      redirect_to day_path(internship.day), notice: "You successfully created an internship!"
    else  
      day = Day.find_by_id(params[:internship][:day_id])
      puts day.inspect
      url = day ? day_path(day) : days_path
      redirect_to url, :flash => { :error => "Your internship could not be saved: #{internship.errors.full_messages.join(', ')} #{host.errors.full_messages.join(', ')}" }
    end
  end

  def new
    @day = Day.find_by(id: params[:day_id])

    @internship = Internship.new
    @internship.host = Person.new
    render :layout => false
  end

  def sign_up_form
    @internship = Internship.find_by(id: params[:id])
    render :layout => false
  end

  def update
    @internship = Internship.find_by(id: params[:id])
    
    respond_with(@internship) do |format|
      internship_attr = params[:internship].merge(:host => @internship.host)

      if @internship.update_attributes(internship_attr)
        flash[:notice] = 'Internship was successfully updated!'
      else
        flash[:error] = "Internship could not be updated! #{@internship.errors.full_messages.join('. ')}"
      end
      format.html { redirect_to day_path(@internship.day) }
      format.js
    end
  end

  def update_intern
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

      # if @internship.assign_intern(params[:email], params[:name]) and new_intern
      #   flash[:notice] = "You successfully became an intern."
      #   PersonMailer.assign_intern_mail(@internship).deliver
      #   PersonMailer.confirmation_for_intern_mail(@internship).deliver
      # elsif @internship.assign_intern(params[:email], params[:name]) and new_intern == false
      #   flash[:notice] = "You successfully updated your position as an intern!"
      # #TODO schöner machen
      # else
      #   flash[:error] = "Your application as an intern failed! #{@internship.errors.full_messages.join(', ')}"
      # end  
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
    @day = @internship.day
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