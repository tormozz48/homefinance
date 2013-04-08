module ApplicationHelper
  def user_full_name
    if !current_user.nil?
        if (!current_user.first_name.nil? &&
           !current_user.last_name.nil? )
          return current_user.first_name + " " + current_user.last_name
        else
          return current_user.email
        end
    end
  end

  def get_sorting_directions(v)
      return content_tag(:option, I18n.t('common.sorting.asc'), :value =>"asc", :selected => v == "asc" ? "selected" : false) +
             content_tag(:option, I18n.t('common.sorting.desc'), :value =>"desc", :selected => v == "desc" ? "selected" : false)
  end
end
