module ApplicationHelper
  def get_sorting_directions(v)
      content_tag(:option, I18n.t('common.sorting.asc'), :value =>'asc', :selected => v == 'asc' ? 'selected' : false) +
      content_tag(:option, I18n.t('common.sorting.desc'), :value =>'desc', :selected => v == 'desc' ? 'selected' : false)
  end
end
