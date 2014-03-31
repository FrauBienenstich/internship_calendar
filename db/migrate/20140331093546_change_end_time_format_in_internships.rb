class ChangeEndTimeFormatInInternships < ActiveRecord::Migration
  def change
    change_column :internships, :end_time, :datetime
  end
end
