class ChangeStartTimeFormatInInternships < ActiveRecord::Migration
  class Internship < ActiveRecord::Base 
  end

  def up
    remove_column :internships, :start_time
    add_column :internships, :start_time, :datetime, :null => false
  end

  def down
    remove_column :internships, :start_time
    change_column :internships, :start_time, :time
  end
end
