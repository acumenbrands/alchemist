Alchemist::RecipeBook.write LocalCustomer, ErpCustomer do

  result do |local_customer|
    ErpCustomer.new
  end

  transfer :first_name
  transfer :last_name

  transfer :email_address, :email

  transfer :join_date, :date do |join_date|
    Date.strptime(join_date, '%m/%d/%Y')
  end

  transpose do
    use :address

    target :street do
      address.split(', ')[0]
    end

    target :city do
      address.split(', ')[1]
    end

    target :state do
      address.split(', ')[2]
    end

    target :zip do
      address.split(', ')[3]
    end
  end

  transpose do
    use :order_history

    target :orders_in_route do
      order_history[:in_route]
    end

    target :shipped_orders do
      order_history[:delivered]
    end
  end

  transfer :user_events, :events do |user_events|
    user_events.map { |event| Alchemist.transmute(event, ErpEvent) }
  end

end
