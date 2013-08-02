Alchemist::RecipeBook.write ErpEvent, UserEvent do

  result do |source|
    UserEvent.new
  end

  transfer :date
  transfer :message, :memo

end
