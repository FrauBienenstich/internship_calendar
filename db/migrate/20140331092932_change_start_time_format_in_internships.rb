class ChangeStartTimeFormatInInternships < ActiveRecord::Migration
  def change
    change_column :internships, :start_time, :datetime
  end
end
