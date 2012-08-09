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

  def getSortingDirectionOptionList
      return content_tag(:option, I18n.t('common.sorting.asc'), :value =>"asc") +
             content_tag(:option, I18n.t('common.sorting.desc'), :value =>"desc")
  end
end
