class InternshipsController < ApplicationController
  respond_to :html

  before_filter :assign_slot, :only => [:create, :new]

  def create
    host = Person.find_or_initialize_by(email: params[:email])
    host.name = params[:name] if host

    internship = Internship.new(:description => params[:description], 
                                :slot_id => @slot.id, 
                                :host => host)

    if host && host.save && internship && internship.save
      ical = internship.to_ical # NOTE TO MYSELF: this has to be called after save!!! before i had a red test
      PersonMailer.confirmation_mail(internship, ical).deliver
      redirect_to day_path(internship.slot.day), notice: "You successfully created an internship!"

    else
      redirect_to day_path(slot.day), :flash => { :error => "Your internship could not be saved: #{internship.errors.full_messages.join(', ')} #{host.errors.full_messages.join(', ')}" }
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

    if params[:commit] == "Remove"
      if @internship.delete_intern!
        flash[:notice] = "Worked"
      else
        flash[:error] = "Did not work"
      end
    else
      @internship.assign_intern(params[:email], params[:name])
    end
    redirect_to day_path(@internship.slot.day)
  end
  

  def edit
    @internship = Internship.find_by(id: params[:id])
    render :layout => false
  end

  def destroy
    @internship = Internship.find(params[:id])

    @internship.destroy

    PersonMailer.delete_internship_mail(@internship).deliver
    redirect_to day_path(@internship.slot.day), notice: "You successfully deleted an internship"
  end

private
  def assign_slot
    @slot = Slot.find_by(id: params[:slot_id])
    unless @slot 
      flash[:error] = "No Slot"
      # redirecting to days because we dont knoe where to go elsewhere
      redirect_to days_path
    end
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