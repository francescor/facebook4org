# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

 def current_user
  session[:current_user]
 end

def number_to_ordinal(num)
  num = num.to_i
  if (10...20)===num
    "#{num}th"
  else
    g = %w{ th st nd rd th th th th th th }
    a = num.to_s
    c=a[-1..-1].to_i
    a + g[c]
  end
end

 def capitalize_first_letter(testo)
  testo[0] = testo[0,1].upcase # attenzione, ke non e' banale
  return testo
 end

 def tab_selected?(action_name, controller_name = nil)
   if controller_name.nil?
     params[:action].to_s == action_name.to_s
   else
     params[:action].to_s == action_name.to_s && params[:controller].to_s == controller_name.to_s
   end
 end

 def display_eventual_pending_status_for_user(user)
   if user.is_pending
     output = ''
     output += "<br/><span style=color:red;>Note: this user has just entered and wait to be approved to be able to use the #{APPLICATION_NAME_WITH_STYLE}</span><br/><br/>"
     return output
   end
 end

 def display_eventual_user_approve_form(user)
   if user.is_pending and @current_user.is_admin
     output = ''
       output += "<form action='#{root_url}admin/approve_user'><input name='user_id' value='#{user.id}' type='hidden' /><input name='commit' type='submit' value='Approve' /></form><br/><br/>"
       #output += "#{form_tag(:controller=>:admin, :action=> :approve_user) do hidden_field_tag 'user_id', user.id; submit_tag 'Approve'; end}"
     return output
   end
 end

 def display_short_eventual_pending_status_for_user(user)
   if user.is_pending
     output = ''
     output += "<span style=color:red;>Not yet approved</span><br/>"
     return output
   end
 end
 def user_job(user)
   #"Role: <i>#{user.job_role_in_words}</i> (area: <i>#{user.job_area_in_words}</i>)<br />   <b>#{user.job_description.capitalize}</b>"
   output = ''
   output += "Manager of the " if user.is_manager
   output += "Area: <i>#{user.job_area_in_words}</i><br />   <b>#{user.job_description}</b><br />"
   output += "<br />"
   output += "<b>Director or President</b> of #{user.organisation.short_name}<br/>" if user.is_boss
   output += "<b>Member of the Board</b> of #{user.organisation.short_name}<br/>"  if user.is_board_member
   output += "Working at #{user.organisation.short_name} for:  <b>#{user.hours_as_worker_in_words}</b><br/>" if (!user.hours_as_worker.nil? && user.hours_as_worker > 0)
   output += "Volunteer at #{user.organisation.short_name} for:  <b>#{user.hours_as_volunteer_in_words}</b><br/>" if (!user.hours_as_volunteer.nil? && user.hours_as_volunteer > 0)
   return output
 end

 def user_short_job(user)
   output = ''
   output += "Manager of the " if user.is_manager
   output += "Area: <i>#{user.job_area_in_words}</i>"
   output += "<br />"
   output += "<b>Director or President</b> of #{user.organisation.short_name}<br/>" if user.is_boss
   output += "<b>Member of the Board</b> of #{user.organisation.short_name}<br/>"  if user.is_board_member
   output += "Working at #{user.organisation.short_name} for:  <b>#{user.hours_as_worker_in_words}</b><br/>" if (!user.hours_as_worker.nil? && user.hours_as_worker > 0)
   output += "Volunteer at #{user.organisation.short_name} for:  <b>#{user.hours_as_volunteer_in_words}</b><br/>" if (!user.hours_as_volunteer.nil? && user.hours_as_volunteer > 0)
   return output
 end

 def user_location(user)
   result = "<b>#{user.country.capitalize}</b> - #{user.city}"
   result += " (#{user.state})" unless user.state.blank?
   return result
 end

 def pretty_location(location)
   # hash di: city, country, state,
   array = [location.city, location.state, location.country]
   array = array-[nil]-['']-[{}] # attenzione, i campi vuoti di location sono hash vuote, ovvero {}
   result = ''
   array.each { |x| result += x.to_s+', '}
   return result[0,result.length-2] #levo gli ultimi due caratteri
 end

 def his_her(user)
   if user.gender == 'female'
     return 'her'
   else
     return 'his'
   end
 end

 def him_her(user)
   if user.gender == 'female'
     return 'her'
   else
     return 'him'
   end
 end

  def he_she(user)
   if user.gender == 'female'
     return 'she'
   else
     return 'he'
   end
 end

 def is_are(size)
   return '[helper error: size is not Fixnum]' if size.class != Fixnum
   if size == 1
     return 'is'
   else
     return 'are'
   end
 end

 def has_have(size)
   return '[helper error: size is not Fixnum]' if size.class != Fixnum
   if size == 1
     return 'has'
   else
     return 'have'
   end
 end

 def he_she_they(users)
   return '[helper error: there is a nil here]' if users.nil?
   if users.size == 1
     if users[0].gender == 'male'
       return 'he'
     else
       return 'she'
     end
   else
     return 'they'
   end
 end

 def him_her_them(users)
   return '[helper error: there is a nil here]' if users.nil?
   if users.size == 1
     if users[0].gender == 'male'
       return 'him'
     else
       return 'her'
     end
   else
     return 'them'
   end
 end


 def his_their(size)
   return '[helper error: size is not Fixnum]' if size.class != Fixnum
   if size == 1
     return 'his'
   else
     return 'their'
   end
 end

 def his_her_their(users)
   return '[helper error: there is a nil here]' if users.nil?
   if users.size == 1
     if users[0].gender == 'male'
       return 'his'
     else
       return 'her'
     end
   else
     return 'their'
   end
 end
 def show_rough_guide_icon(country)
      render :inline => "<%= link_to image_tag('rough_guide_icon.gif', :alt => ' ',:title => 'see Rough Guide #{country.upcase}'), 'http://changingroom.teh.net/wiki/index.php/Rough_guide_#{country}', {:target => '_blank'} %>"
 end

 def show_users_pic(users, n = 20)
   # TODO separa gli amici dai non amici
   if users.nil?
     return ''
   else
    output = ''

    for user in users.first(n)
      output += "<%= link_to fb_profile_pic(#{user.uid}, :linked => false, :size => 'square'), :controller => 'users', :action => 'show', :id => #{user.id} %>&ensp;"
    end
    output += '<b>...</b>' if users.size > n
    output += '<br />'
    render :inline => output
   end
 end

 def render_is_your_friend_or_add_as_friend(user)
   output = ''
   unless user == @current_user
     output += "<fb:if-is-friends-with-viewer uid='#{user.uid}'>" +
               "#{he_she(user).capitalize} is your friend" +
               "<fb:else>" +
               "<a href='http://www.facebook.com/addfriend.php?id=#{user.uid.to_s}'>Add #{fb_name(user.uid, :capitalize => true,  :linked => false,  :firstnameonly=> true)} as a friend</a> " +
               "</fb:else>" +
               "</fb:if-is-friends-with-viewer>" +
               "<br />"
   end
   return output
 end

 def render_send_message(user)
   output = ''
   unless user == @current_user
     output += "<a href='http://www.facebook.com/inbox/?compose&id=#{user.uid}'>Send  #{fb_name(user.uid, :capitalize => true,  :linked => false,  :firstnameonly=> true)} a message</a> " +
               "<br />"
   end
   return output
 end

 def render_view_photos(user)
   output = ''
   unless user == @current_user
     output += "<a href='http://www.facebook.com/profile.php?v=photos&id=#{user.uid.to_s}'>View Photos of #{fb_name(user.uid, :capitalize => true,  :linked => false,  :firstnameonly=> true)}</a>" +
               "<br />"

   end
   return output
 end
 
end
