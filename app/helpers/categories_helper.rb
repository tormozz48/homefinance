module CategoriesHelper
  def getCategoryColor(category)
    return category.color.nil? ? '#fff' : '#'+category.color;
  end

  def getCategoriesSortingOptionList(v)
    return content_tag(:option, I18n.t('field.common.name'), :value =>"name", :selected => v == "name" ? "selected" : false) +
           content_tag(:option, I18n.t('field.common.description'), :value =>"description", :selected => v == "description" ? "selected" : false) +
           content_tag(:option, I18n.t('field.category.color'), :value =>"color", :selected => v == "color" ? "selected" : false)
  end
end
