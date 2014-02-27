class Internship < ActiveRecord::Base

  validates :host, presence: true
  validates :slot_id, presence: true
  validates :description, presence: true

  belongs_to :slot
  belongs_to :host, :class_name => "Person"
  belongs_to :intern, :class_name => "Person"



end
