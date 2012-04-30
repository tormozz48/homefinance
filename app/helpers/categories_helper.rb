module CategoriesHelper
  def getCategoryColor(category)
    return category.color.nil? ? '#fff' : '#'+category.color;
  end

end
