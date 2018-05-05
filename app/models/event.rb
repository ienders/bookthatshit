class Event < ActiveRecord::Base

  validates_presence_of :date, :description, :booked_by_email, :booked_by_name

  scope :owned_by, -> (email) { where(booked_by_email: email) }
  scope :ordered, -> { order(:date) }

end
