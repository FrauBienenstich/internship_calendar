class DropSlots < ActiveRecord::Migration
  def up
    drop_table :slots
  end

  def down
    create_table :slots do |t|
      t.integer "day_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "start_time", null: false
      t.datetime "end_time",   null: false
    end
  end
end
