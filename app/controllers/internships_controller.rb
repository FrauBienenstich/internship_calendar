class InternshipsController < ApplicationController

  def create

    host = Person.find_or_initialize_by(email: params[:email])
    host.name = params[:name]
    slot_id = params[:slot_id]
    desc = params[:description]
    puts 'a host'
    puts host.inspect
    internship = Internship.new(:description => desc, :slot_id => slot_id, :host => host)# still dont know what happens afterwards with it!

    if host.save && internship.save
      PersonMailer.confirmation_mail(host).deliver
      redirect_to current_days_path, notice: "You successfully created an internship!"
    else
      redirect_to current_days_path, :flash => { :error => "Your internship could not be saved: #{internship.errors.full_messages.join(', ')} #{host.errors.full_messages.join(', ')}" }
    end
  end

  def destroy
    @internship = Internship.find_by(id: params[:id])
    @internship.destroy

    redirect_to current_days_path, notice: "You successfully deleted an internship"
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