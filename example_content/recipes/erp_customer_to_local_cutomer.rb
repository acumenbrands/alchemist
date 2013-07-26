require 'time'

Alchemist::RecipeBook.write ErpCustomer, LocalCustomer do

  result {
    LocalCustomer.new
  }

  source_method :name do |name|
    self.first_name, self.last_name = *name.split(' ')
  end

  transfer :email_address, :email

  source_method :event_log do |event_log|
    event_log.each do |event|
      date = Date.parse(event.datetime.split(' ', 2).first)
      time = Time.parse(event.datetime)

      self.user_events << UserEvent.new(event.name, date, time)
    end
  end

end
