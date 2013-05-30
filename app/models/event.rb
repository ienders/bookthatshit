class Event < ActiveRecord::Base

  validates_presence_of :date, :description, :booked_by_email, :booked_by_name

  attr_accessible :date, :description, :booked_by_email, :booked_by_name

  scope :owned_by, -> (email) { where(booked_by_email: email) }
  scope :ordered, -> { order(:date) }

  def self.new_with_session(attrs, session)
    new(attrs.merge(booked_by_email: session[:email], booked_by_name: session[:name]))
  end

  def update_safe_attributes(attrs)
    attrs.delete :booked_by_email
    attrs.delete :booked_by_name
    update_attributes(attrs)
  end

end