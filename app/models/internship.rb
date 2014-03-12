class Internship < ActiveRecord::Base

  validates :host, presence: true
  validates :slot_id, presence: true
  validates :description, presence: true

  belongs_to :slot
  belongs_to :host, :class_name => "Person"
  belongs_to :intern, :class_name => "Person"



  def delete_intern!
    deleted_intern = self.intern
    self.intern_id = nil

    if save
      PersonMailer.delete_intern_mail(self, deleted_intern).deliver
    else 
      false
    end
  end

  def assign_intern(email)

    self.intern = Person.find_or_initialize_by(:email => email) # not yet saved!
    save
    #self.intern.name = params[:name]
    
  #   if @internship.intern.save && @internship.save
  #     flash[:notice] = "You successfully became an intern!"
  #     PersonMailer.assign_intern_mail(@internship).deliver
  #   else
  #     flash[:error] = "Your application as an intern failed!"
  #   end
  end


end
