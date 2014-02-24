class CreateInternships < ActiveRecord::Migration
  def change
    create_table :internships do |t|
      t.string :host
      t.string :intern

      t.timestamps
    end
  end
end
