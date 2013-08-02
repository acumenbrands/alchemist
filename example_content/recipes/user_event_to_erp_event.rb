Alchemist::RecipeBook.write UserEvent, ErpEvent do

  result do |source|
    ErpEvent.new
  end

  transfer :date
  transfer :memo, :message

end
