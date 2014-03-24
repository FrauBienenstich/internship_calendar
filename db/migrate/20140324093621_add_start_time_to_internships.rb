class AddStartTimeToInternships < ActiveRecord::Migration
  def change
    add_column :internships, :start_time, :time
  end
end
