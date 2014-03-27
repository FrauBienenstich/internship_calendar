class InternshipsController < ApplicationController
  respond_to :html

  def create
    host = Person.find_or_initialize_by(email: params[:email])
    host.name = params[:name] if host
    puts "PARAMS #{params}"

    # start_time = Date.new *new_start_time_from_hash(params[:internship])
    # end_time = Date.new *new_end_time_from_hash(params[:internship])
    
    start_time = DateTime.new(params["internship"]["start_time(1i)"].to_i, 
                        params["internship"]["start_time(2i)"].to_i,
                        params["internship"]["start_time(3i)"].to_i,
                        params["internship"]["start_time(4i)"].to_i,
                        params["internship"]["start_time(5i)"].to_i)

    end_time = DateTime.new(params["internship"]["end_time(1i)"].to_i, 
                        params["internship"]["end_time(2i)"].to_i,
                        params["internship"]["end_time(3i)"].to_i,
                        params["internship"]["end_time(4i)"].to_i,
                        params["internship"]["end_time(5i)"].to_i)
    
    internship = Internship.new(:description => params[:description], 
                                :day_id => params[:day_id],
                                :host => host,
                                :start_time => start_time,
                                :end_time => end_time)




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

    ical = @internship.to_ical

    if params[:commit] == "Remove"
      if @internship.delete_intern!
        flash[:notice] = "Worked"
      else
        flash[:error] = "Did not work"
      end
    else
      
      #still have to write tests for this:
  
          
      if @internship.assign_intern(params[:email], params[:name])
        flash[:notice] = "You successfully became an intern."
        PersonMailer.assign_intern_mail(@internship, ical).deliver
        PersonMailer.confirmation_for_intern_mail(@internship, ical).deliver
      else
        flash[:error] = "Your application as an intern failed!"
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




  # def new_start_time_from_hash(params)
  #   %w(1 2 3 4 5).map {|e| params["start_time({e}i)"].to_i}
  # end

  # def new_end_time_from_hash(params)
  #   %w(1 2 3 4 5).map {|e| params["end_time({e}i)"].to_i}
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