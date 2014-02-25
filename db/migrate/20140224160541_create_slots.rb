class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.string :name
      t.integer :day_id

      t.timestamps
    end
  end
end
