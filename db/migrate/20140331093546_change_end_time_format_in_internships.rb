class ChangeEndTimeFormatInInternships < ActiveRecord::Migration
  class Internship < ActiveRecord::Base end

  def up
    Internship.update_all("end_time = NULL")
    change_column :internships, :end_time, :datetime, :null => false
    Internship.update_all("end_time = #{(DateTime.now + 1.hour).to_s(:db)}")
  end

  def down
    change_column :internships, :end_time, :time
  end
end
