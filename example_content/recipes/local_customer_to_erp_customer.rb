Alchemist::RecipeBook.write LocalCustomer, ErpCustomer do

  result do |source|
    ErpCustomer.new
  end

  transfer :order_count, :orders do |order_count|
    order_count.to_s
  end

  transfer :email, :email_address

  source_method :user_events do |user_events|
    user_events.map do |event|
      datetime = "#{event.date} #{event.time}"
      erp_event = ErpEvent.new(event.type, datetime, 'Created by Alchemist')

      self.event_log << erp_event
    end
  end

end
