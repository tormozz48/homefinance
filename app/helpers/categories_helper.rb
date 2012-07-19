module CategoriesHelper
  def getCategoryColor(category)
    return category.color.nil? ? '#fff' : '#'+category.color;
  end

  def getCategoriesSortingOptionList
    str = ""
    str += "<option value='name'>"+I18n.t('field.common.name')+"</option>"
    str += "<option value='description'>"+I18n.t('field.common.description')+"</option>"
    str += "<option value='color'>"+I18n.t('field.category.color')+"</option>"
    return str
  end
end
