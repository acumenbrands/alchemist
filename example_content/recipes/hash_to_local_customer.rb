Alchemist::RecipeBook.write Hash, LocalCustomer do
  result do
    LocalCustomer.new
  end

  transfer :first_name
  transfer :last_name
end
