module CategoriesHelper
  def get_color(category)
    category.color.nil? ? '#fff' : '#'+category.color
  end
end
