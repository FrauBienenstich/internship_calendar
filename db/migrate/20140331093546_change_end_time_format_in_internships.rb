class ChangeEndTimeFormatInInternships < ActiveRecord::Migration

  def up
    remove_column :internships, :end_time
    add_column :internships, :end_time, :datetime, :null => false, :default => (DateTime.now + 1.hour).to_s(:db)
  end

  def down
    remove_column :internships, :end_time
    add_column :internships, :end_time, :time
  end
end
