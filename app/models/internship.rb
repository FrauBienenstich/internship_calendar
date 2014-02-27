class Internship < ActiveRecord::Base

  validates :host, presence: true #wieso kann name immernoch doppelt sein??
  validates :slot_id, presence: true
  validates :description, presence: true
  validates :host, uniqueness: true

  validates :host, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }

  belongs_to :slot
  belongs_to :host, :class_name => "Person"
  belongs_to :intern, :class_name => "Person"



end
