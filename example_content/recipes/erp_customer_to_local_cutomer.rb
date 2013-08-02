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

  transpose do
    use :street, :city, :state, :zip

    target :address, :shipping_address do
      "#{street}, #{city}, #{state}, #{zip}"
    end
  end

  transpose do
    use :orders_in_route, :shipped_orders

    target :order_history do
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
