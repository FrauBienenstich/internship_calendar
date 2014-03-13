class ChangeSlotNameToDatetime < ActiveRecord::Migration
  def change
    add_column :slots, :start_time, :datetime, null: false
    add_column :slots, :end_time, :datetime, null: false
    remove_column :slots, :name
  end
end
