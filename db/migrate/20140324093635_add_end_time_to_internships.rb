class AddEndTimeToInternships < ActiveRecord::Migration
  def change
    add_column :internships, :end_time, :time
  end
end
