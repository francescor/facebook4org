module MainHelper

  def strong_if (text, condition)
    if condition
      "<strong>#{text}</strong>"
    else
      text
    end
  end

  def show_infopoint_icon(user)
    # TODO  code below gives error:  undefined method `relative_path' for #<ActionView::InlineTemplate:0x2ac3e22ed3f0>
#    if user.infopoint == 'yes' && !user.city.blank?
#      render :inline => "<%= image_tag('user_infopoint_yes_icon.gif', :alt => ' ', :title => 'Willing to give information about #{user.city.upcase}') %>"
#    end
  end

  def show_hosting_icon(user)
    case user.hosting
    when 'yes'
      render :inline => "<%= image_tag('user_hosting_yes_icon.gif',  :alt => ' ', :title => 'Available for hosting') %>"
    when 'maybe'
      render :inline => "<%= image_tag('user_hosting_maybe_icon.gif',:alt => ' ', :title => 'Maybe available for hosting') %>"
    else
      render :inline => "<%= image_tag('user_hosting_no_icon.gif',  :alt => ' ',  :title => 'Not available for hosting') %>"
    end
  end

  def show_exchange_preferences(user)
    result = ''
    result += 'Work<br> ' if user.go_as_worker > 0
    result += 'Volunteering<br> ' if user.go_as_volunteer > 0
    result += 'Internship/Training<br> ' if user.go_as_intern > 0
    result += 'Visit<br> ' if user.go_as_visitor > 0
    return result
  end



  def go_info_in_words_info_for_current
    if @current_user.go_info.blank? &&
          @current_user.go_as_worker + @current_user.go_as_volunteer + @current_user.go_as_intern + @current_user.go_as_visitor > 0
      render :inline => "<i>none (maybe you should <%= link_to 'write', :controller => 'users', :action=>'edit_preferences', :id => @current_user -%> something here)</i>"
    elsif @current_user.go_info.blank?
      '<i>none</i>'
    else
      "<br /><b>#{h @current_user.go_info}</b>"
    end
  end



end
