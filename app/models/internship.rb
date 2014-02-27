class Internship < ActiveRecord::Base

  validates :host, presence: true #wieso kann name immernoch doppelt sein??
  validates :slot_id, presence: true
  validates :description, presence: true
  validates :host, uniqueness: true

  belongs_to :slot
  belongs_to :host, :class_name => "Person"
  belongs_to :intern, :class_name => "Person"



end
