class InternshipsController < ApplicationController
  respond_to :html

  def create

    host = Person.find_or_initialize_by(email: params[:email])
    host.name = params[:name]
    slot_id = params[:slot_id]
    desc = params[:description]

    slot = Slot.find_by(id: slot_id) # ist das hier guter Stil? oder übergebe ich confirmation_mail zu viele Argumente(host, time, day, desc)?
    time = slot.name

    internship = Internship.new(:description => desc, :slot_id => slot_id, :host => host)# still dont know what happens afterwards with it!
    
    day = internship.slot.day

    if host.save && internship.save
      PersonMailer.confirmation_mail(internship).deliver
      redirect_to current_days_path, notice: "You successfully created an internship!"
    else
      redirect_to current_days_path, :flash => { :error => "Your internship could not be saved: #{internship.errors.full_messages.join(', ')} #{host.errors.full_messages.join(', ')}" }
    end
  end

  def new
    @slot = Slot.find_by(id: params[:slot_id])

    @internship = @slot.internships.build
    render :layout => false
  end

  def sign_up_form
    @internship = Internship.find_by(id: params[:id])
    render :layout => false
  end

  def update
    @internship = Internship.find_by(id: params[:id])
    
    host = @internship.host
    intern = @internship.intern

    new_intern = Person.find_or_initialize_by(email: params[:email])
    new_intern.name = params[:name]

    time = @internship.slot.name
    day = @internship.slot.day
    description = @internship.description


    result = true

    if params[:commit] == "Remove"
      deleted_intern = @internship.intern
      delete_intern(@internship)
      PersonMailer.delete_intern_mail(@internship, deleted_intern).deliver

    else
      result = assign_intern(@internship)

      PersonMailer.assign_intern_mail(host, new_intern, time, day, description).deliver
    end
    redirect_to day_path(@internship.slot.day)
  end

  def edit
    @internship = Internship.find_by(id: params[:id])
    render :layout => false
  end

  def destroy
    @internship = Internship.find(params[:id])
    host = @internship.host
    intern = @internship.intern
    time = @internship.slot.name
    day = @internship.slot.day
    description = @internship.description

    @internship.destroy


    PersonMailer.delete_internship_mail(@internship).deliver
    redirect_to current_days_path, notice: "You successfully deleted an internship"
  end

protected

  def assign_intern(internship)
    internship.intern = Person.find_or_initialize_by(email: params[:email])
    internship.intern.name = params[:name]
    
    if internship.intern.save && internship.save
      flash[:notice] = "You successfully became an intern!"
    else
      flash[:error] = "Your application as an intern failed!"
    end
  end

  def delete_intern(internship)
    internship.intern_id = nil
    internship.save
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