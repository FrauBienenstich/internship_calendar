class InternshipsController < ApplicationController


  respond_to :html

  def create

    host = Person.find_or_new(params[:email], params[:name])

    # start_time = Date.new *new_start_time_from_hash(params[:internship])
    # end_time = Date.new *new_end_time_from_hash(params[:internship])

    start_time = make_time("start_time")
    end_time = make_time("end_time")
    # start_time = DateTime.new(params["internship"]["start_time(1i)"].to_i, 
    #                     params["internship"]["start_time(2i)"].to_i,
    #                     params["internship"]["start_time(3i)"].to_i,
    #                     params["internship"]["start_time(4i)"].to_i,
    #                     params["internship"]["start_time(5i)"].to_i)
    # instead of getting day and month through params i could also access internship.day.date etc

    # end_time = DateTime.new(params["internship"]["end_time(1i)"].to_i, 
    #                     params["internship"]["end_time(2i)"].to_i,
    #                     params["internship"]["end_time(3i)"].to_i,
    #                     params["internship"]["end_time(4i)"].to_i,
    #                     params["internship"]["end_time(5i)"].to_i)
    #TODO Refactor!
    
    internship = Internship.new(:description => params[:description], 
                                :day_id => params[:day_id],
                                :host => host,
                                :start_time => start_time,
                                :end_time => end_time)

    if host && host.save && internship && internship.save
      PersonMailer.confirmation_mail(internship).deliver
      redirect_to day_path(internship.day), notice: "You successfully created an internship!"
      puts "when saved #{internship.inspect}"
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

  private

  def make_time(whut)
    begin
      ts = make_time_string(whut)
      puts "#{whut} -> #{ts}"
      puts "TS #{ts}" #is empty, WHY???
      return Time.zone.parse(ts)
    rescue
      nil
    end
  end

  def make_time_string(whut)
    puts "PARAMS #{params}"
    y = params["internship"]["#{whut}(1i)"]
    m = params["internship"]["#{whut}(2i)"]
    d = params["internship"]["#{whut}(3i)"]
    hh = params["internship"]["#{whut}(4i)"]
    mm = params["internship"]["#{whut}(5i)"]

    puts "STRING #{y}-#{pad(m)}-#{pad(d)} #{pad(hh)}:#{pad(mm)}"
    "#{y}-#{pad(m)}-#{pad(d)} #{pad(hh)}:#{pad(mm)}"
  end

  def pad(num, len = 2)
    num.to_s.rjust(len, '0')
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