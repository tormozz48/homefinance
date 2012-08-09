module CategoriesHelper
  def getCategoryColor(category)
    return category.color.nil? ? '#fff' : '#'+category.color;
  end

  def getCategoriesSortingOptionList
    return content_tag(:option, I18n.t('field.common.name'), :value =>"name") +
           content_tag(:option, I18n.t('field.common.description'), :value =>"description") +
           content_tag(:option, I18n.t('field.category.color'), :value =>"color")
  end
end
