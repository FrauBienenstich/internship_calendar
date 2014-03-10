class InternshipsController < ApplicationController
  respond_to :html

  def create
    host = Person.find_or_initialize_by(email: params[:email])
    host.name = params[:name]
    slot_id = params[:slot_id]
    desc = params[:description]

    internship = Internship.new(:description => desc, :slot_id => slot_id, :host => host)# still dont know what happens afterwards with it!

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

    if params[:commit] == "Remove"
      delete_intern
    else
      assign_intern
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
    redirect_to current_days_path, notice: "You successfully deleted an internship"
  end

protected

  def delete_intern
    @deleted_intern = @internship.intern

    @internship.intern_id = nil
    @internship.save

    PersonMailer.delete_intern_mail(@internship, @deleted_intern).deliver
  end

  def assign_intern
    @internship.intern = Person.find_or_initialize_by(email: params[:email])
    @internship.intern.name = params[:name]
    
    if @internship.intern.save && @internship.save
      flash[:notice] = "You successfully became an intern!"
      PersonMailer.assign_intern_mail(@internship).deliver
    else
      flash[:error] = "Your application as an intern failed!"
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