class ChangeStartTimeFormatInInternships < ActiveRecord::Migration

  def up
    remove_column :internships, :start_time
    add_column :internships, :start_time, :datetime, :null => false, :default => DateTime.now.to_s(:db)
  end

  def down
    remove_column :internships, :start_time
    change_column :internships, :start_time, :time
  end
end
