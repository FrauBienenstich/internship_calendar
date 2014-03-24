class RemoveSlotIdFromInternships < ActiveRecord::Migration
  def up
    remove_column :internships, :slot_id
  end

  def down
    add_column :internships, :slot_id, :integer
  end
end
