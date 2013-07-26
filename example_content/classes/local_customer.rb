require 'date'

class LocalCustomer

  attr_accessor :first_name, :last_name, :order_count, :email

  attr_reader   :user_events

  def initialize
    # This array can stand in for a db association in your ORM of choice
    @user_events = []
  end

  def full_name
    "#{first_name} #{last_name}"
  end

end

class UserEvent

  attr_reader :type, :date, :time

  def initialize(type, date, time)
    @type = type
    @date = date || Date.today
    @time = time || Time.now
  end

end
