class AddDayIdToInternships < ActiveRecord::Migration
  def change
    add_column :internships, :day_id, :integer
  end
end
