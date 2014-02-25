class CreateInternships < ActiveRecord::Migration
  def change
    create_table :internships do |t|
      t.integer :host_id
      t.integer :intern_id

      t.timestamps
    end
  end
end
