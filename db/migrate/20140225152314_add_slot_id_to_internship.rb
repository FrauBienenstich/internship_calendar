class AddSlotIdToInternship < ActiveRecord::Migration
  def change
    add_column :internships, :slot_id, :integer
  end
end
