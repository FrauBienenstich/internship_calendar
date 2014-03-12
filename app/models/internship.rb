class Internship < ActiveRecord::Base

  validates :host, presence: true
  validates :slot_id, presence: true
  validates :description, presence: true

  belongs_to :slot
  belongs_to :host, :class_name => "Person"
  belongs_to :intern, :class_name => "Person"



  def delete_intern
    puts self.inspect
    @internship = self
    puts "@internship #{@internship.inspect}"
    @deleted_intern = @internship.intern
    puts "@internship.intern #{@internship.intern}"
    @internship.intern_id = nil
    @internship.save # how do i test this line?

    puts "DELETED: #{@deleted_intern}"
    PersonMailer.delete_intern_mail(@internship, @deleted_intern).deliver
  end

  # def assign_intern
  #   @internship.intern = Person.find_or_initialize_by(email: params[:email])
  #   @internship.intern.name = params[:name]
    
  #   if @internship.intern.save && @internship.save
  #     flash[:notice] = "You successfully became an intern!"
  #     PersonMailer.assign_intern_mail(@internship).deliver
  #   else
  #     flash[:error] = "Your application as an intern failed!"
  #   end
  # end


end
