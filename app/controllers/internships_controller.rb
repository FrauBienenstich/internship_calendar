class InternshipsController < ApplicationController

  def create
    slot_id = params[:internship][:slot_id]
    desc = params[:internship][:description]
    @internship = Internship.new(:description => desc, :slot_id => slot_id)

    if @internship.save
      redirect_to current_days_path, notice: "You successfully created an internship!"
    else
      redirect_to current_days_path, :flash => { :error => "Your internship could not be saved" }
      #error: "Your internship could not be saved"
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