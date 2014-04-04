class ChangeStartTimeFormatInInternships < ActiveRecord::Migration
  class Internship < ActiveRecord::Base 
  end

  def up
    Internship.update_all("start_time = NULL")
    change_column :internships, :start_time, :datetime, :null => false
    Internship.update_all("start_time = #{DateTime.now.to_s(:db)}")
  end

  def down
    change_column :internships, :start_time, :time
  end
end
