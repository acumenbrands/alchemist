Alchemist::RecipeBook.write LocalCustomer, Hash do
  result do
    {}
  end

  transfer :first_name
  transfer :last_name
end
