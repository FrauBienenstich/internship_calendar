class AddDescriptionToInternships < ActiveRecord::Migration
  def change
    add_column :internships, :description, :text
  end
end
