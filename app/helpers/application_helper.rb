module ApplicationHelper
  def user_full_name
    if !current_user.nil?
        if (!current_user.first_name.nil? &&
           !current_user.last_name.nil? &&
           !current_user.first_name.empty? &&
           !current_user.last_name.empty?)
          return current_user.first_name + " " + current_user.last_name
        elsif (!current_user.first_name.nil?
              !current_user.first_name.empty?)
          return current_user.first_name
        elsif (!current_user.last_name.nil? &&
              !current_user.last_name.empty?)
          return current_user.last_name
        else
          return current_user.email
        end
    end
  end
end
