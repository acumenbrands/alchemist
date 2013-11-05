Alchemist::RecipeBook.write ErpCustomer, LocalCustomer do

  result do |erp_customer|
    LocalCustomer.new
  end

  guard :first_name do |first_name|
    first_name != "John"
  end

  transfer :first_name
  transfer :last_name

  transfer :email, :email_address

  transfer :date, :join_date do |date|
    date.strftime('%m/%d/%Y')
  end

  aggregate_onto :address do
    from :street, :city, :state, :zip

    with do
      "#{street}, #{city}, #{state}, #{zip}"
    end
  end

  aggregate_onto :shipping_address do
    from :street, :city, :state, :zip

    with do
      "#{street}, #{city}, #{state}, #{zip}"
    end
  end

  aggregate_onto :order_history do
    from :orders_in_route, :shipped_orders

    with do
      {
        in_route:  orders_in_route,
        delivered: shipped_orders
      }
    end
  end

  transfer :events, :user_events do |events|
    events.map { |event| Alchemist.transmute(event, UserEvent) }
  end

end

Alchemist::RecipeBook.write ErpCustomer, LocalCustomer, :mess_up_email do

  transfer :email, :email_address do |email|
    email.gsub('@', '')
  end

end
