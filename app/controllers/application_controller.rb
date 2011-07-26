# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #
  # La seguente disabilitata vista la sua incompatibilita' con facebooker (vedi mangino p.39)
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details
  #
  # la seguente per Geokit TODO sicuro che vada qui ?
  include GeoKit::Geocoders
  # il seguente necessario per il metodo u() usato per url per mappa
  include ERB::Util
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  ensure_application_is_installed_by_facebook_user#  :except => [:welcome]
  # ensure_authenticated_to_facebook :except => 'welcome'
  before_filter :setup_db_user#, :except => [:welcome]
  #before_filter :ensure_have_answered_initial_questions # , :except => 'index'

  before_filter :ensure_organisation_is_set#, :except => [:welcome]
#  before_filter :check_belonging_to_admission_group_and_update_admin_status#, :except => [:welcome]
  before_filter :ensure_user_have_signup_with_all_step#, :except => [:welcome]
  before_filter :ensure_have_entered_email_address_and_new_profile_data # you can remove this when all OLD users will have inserted their email
  before_filter :ensure_user_is_approved #, :except => [:welcome]
  #before_filter :ensure_organisation_is_set, :except =>  [:welcome, :index, :select_org, :new, :update]
  #before_filter :set_default_profile_if_needed, :except => [:login, :select]
  #before_filter :check_and_set_user_group, :except => [:login, :select]
  # on the next one we have to allow "update" since it's needed in case user edit does not pass validation
  # TODO escludere 'new' o rinominarla, altrimenti uno crea un new user
  #before_filter :ensure_user_have_signup_with_all_step, :except => [:login, :update, :new, :edit_profile, :edit_preferences]
  #
  # TODO aggiungere il seguente come indicato da README di facebooker
  filter_parameter_logging :fb_sig_friends
  #


  # BEGIN setup_db_user
  def setup_db_user
    # Grab the facebook user if we have one
    # and store it in the session
    unless(@current_user || facebook_params.empty?)
      # entro solo quando @current_user non esiste && se facebook_params esiste
      user_id =     facebook_params["user"]
      session_key = facebook_params["session_key"]
      expires =     facebook_params["expires"]
      user = User.ensure_create_user(user_id)
      #
      # poco chiaro il discorso di "last_access"
      if (user.session_key != session_key || user.last_access.nil? || (user.last_access + 60*60) < Time.now)
        user.session_key = session_key
        user.session_expires = expires
        #@previous_access = user.last_access
        user.last_access = Time.now
        # il seguente necessario per poter modificare users qui, quando l'utente NON ha completato il profilo
        user.save_with_validation(false) # necessario
      end
      @current_user = user
      # update cached_data_each_time_user_login
      @current_user.facebooker_session = (@facebook_session || session[:facebook_session])
      #@current_user.cached_name = @current_user.facebooker_session.user.name
      #@current_user.cached_profile_url = @current_user.facebooker_session.user.profile_url
      #@current_user.cached_pic_square = @current_user.facebooker_session.user.pic_square
      #@current_user.save_with_validation(false)
      session[:logged_in] = true
    end
    # la seguente non la uso
    #session[:current_user] = @current_user
    @current_user.facebooker_session = (@facebook_session || session[:facebook_session])
  end
  # END setup_db_user
  #
  def ensure_organisation_is_set
      redirect_to :controller => 'login', :action => 'select_org' if @current_user.organisation.nil?
  end
  #
  def set_default_profile_if_needed
    set_default_profile(@current_user) if @current_user.signup_step == 0 # if user_has_just_been_created
  end
  #
  def ensure_user_is_approved
    if @current_user.is_pending
      redirect_to :controller => 'main', :action => 'index_for_pending_users'
    end
  end
#  def check_belonging_to_admission_group_and_update_admin_status
#    #unless @current_user.organisation.nil? # pleonastico, ma meglio metterlo
#
#      # NEW:
#      # non possiamo usare le sessioni, in quanto ci arrivano spesso chiamate POST per via dei commenti
#      # quindi mettiamo in cache l'appartenenza al gruppo.
#      # ogni tanto si deve CANCELLARE (portare a false) il valore di "cached_belongs_to_admission_group"
#      # che così viene rigenerato quando gli utenti tornano
#      unless @current_user.cached_belongs_to_admission_group == true
#        group_gids = @current_user.facebooker_session.user.groups.map{|group| group.gid}
#        if group_gids.include?(ADMISSION_GROUP_GID.to_i)
#            @current_user.cached_belongs_to_admission_group = true
#            @current_user.save_with_validation(false)
#          if group_gids.include?(ADMIN_GROUP_GID.to_i)
#            if !@current_user.is_admin
#              @current_user.is_admin = true
#              @current_user.save_with_validation(false)
#            end
#          else
#            if @current_user.is_admin
#              @current_user.is_admin = false
#              @current_user.save_with_validation(false)
#            end
#          end
#        else
#          # we want to keep all users that could not log in, so we don't destroy them
#          # @fb_user.destroy
#          flash[:error] = "You do not belong to the #{ADMISSION_GROUP_LINKED_NAME} <br/><br/><small>Access to this #{APPLICATION_NAME} is reserved for Trans Europe Halles (TEH) people.<br />"+
#                          "If your organisation is part of #{MAIN_ORG_SHORT_NAME}, then join the closed #{ADMISSION_GROUP_LINKED_NAME}! How? Go to the #{ADMISSION_GROUP_LINKED_NAME} page and click on <i>Request to join</i>.  Your request will be manually approved by its administrators <i>(it will take some hours)</i>, and consequently you'll be able to come back here to use the #{APPLICATION_NAME_WITH_STYLE}.<br>"+
#                          "<br />See the <a href='#{CHANGING_ROOM_LINK}'>Changing Room Project homepage</a> for more information about the project.<br></small>", "."
#          #session[:current_user] = nil
#          #@current_user = nil
#          redirect_to :controller => 'login', :action => 'welcome'
#          return
#        end
#      end
#    #end #unless
#  end

  #  def publish_story_to_user
  #    if(@previous_access && (@previous_access < Time.parse(Date.today.to_s)) )
  #      FacebookPublisher.deliver_nudge_story(current_user)
  #    end
  #  end

  def set_default_profile_for_current_user
     # set defaul value ONLY when user is created the first time
     # NOTE: user in the right side is the Facebook user :) thank to method missing!
    #@current_user.gender = @current_user.facebooker_session.user.sex
    @current_user.cached_name        = @current_user.facebooker_session.user.name
    @current_user.cached_pic_square  = @current_user.facebooker_session.user.pic_square
    @current_user.cached_profile_url = @current_user.facebooker_session.user.profile_url
    #unless @current_user.facebooker_session.user.birthday.nil?
    #  @current_user_age = Time.now.to_datetime.year - @current_user.facebooker_session.user.birthday.to_datetime.year
    #  @current_user.age = age_to_code(@current_user_age)
    #end
#    unless @current_user.facebooker_session.user.hometown_location.nil?
#      # forget about current_location, we copy data from hometown location
#      @current_user.city = @current_user.facebooker_session.user.hometown_location.city
#      @current_user.state = @current_user.facebooker_session.user.hometown_location.state
#      #if @current_user.hometown_location.zip.include?('{') || (@current_user.hometown_location.zip == "" || 0)
#      if !@current_user.facebooker_session.user.hometown_location.zip.to_s.blank? && @current_user.facebooker_session.user.hometown_location.zip.to_s != "0"
#        @current_user.post_code = @current_user.facebooker_session.user.hometown_location.zip.to_s
#      else
#        # in this case we don't set the zip, unless we can get it from the current location
#        unless @current_user.facebooker_session.user.current_location.nil?
#          if @current_user.facebooker_session.user.current_location.city == @current_user.facebooker_session.user.hometown_location.city &&
#              !@current_user.facebooker_session.user.current_location.zip.to_s.blank? && @current_user.facebooker_session.user.current_location.zip.to_s != "0"
#            @current_user.post_code =  @current_user.facebooker_session.user.current_location.zip.to_s  # to_s get rid of the {} case
#          end
#        end
#      end
#      @current_user.country = @current_user.facebooker_session.user.hometown_location.country
#    end
    # last change to get postal_code & state
#    if (@current_user.post_code.blank? || @current_user.state.blank?) && @current_user.country && @current_user.city
#      loc = @current_user.get_geocoder_location
#      if loc.success
#        @current_user.post_code = loc.zip if @current_user.post_code.blank? && !loc.zip.nil?
#        @current_user.state = loc.state if @current_user.state.blank?       && !loc.state.nil?
#      end
#    end
    @current_user.signup_step = 1
    @current_user.save_with_validation(false)
  end

#  def update_admin_state_by_checking_if_current_user_belongs_to_admin_group
#    # TODO manca il controllo una tantum per vedere se utente admin appartiene ancora al gruppo admin
#    if get_possible_fb_groups_for_current_user.include?(ADMIN_GROUP_GID.to_i)
#      if !@current_user.is_admin
#        @current_user.is_admin = true
#        @current_user.save_with_validation(false)
#      end
#    else
#      if @current_user.is_admin
#        @current_user.is_admin = false
#        @current_user.save_with_validation(false)
#      end
#    end
#  end

  def ensure_is_admin
    unless @current_user.is_admin
      flash[:error] = "Error: you must belong to the Administrator's group do this"
      redirect_to :controller => 'main'
    end
  end

  #def ensure_have_answered_initial_questions
  #  unless current_user_have_answered_initial_questions?
  #    redirect_to :controller => 'users', :action => 'edit', :id=> session[:current_user]
  #  end
  #end

  def ensure_user_have_signup_with_all_step
    case @current_user.signup_step
    when 1
      redirect_to :controller => 'users', :action => 'edit_profile',     :id=> @current_user
    when 2
      redirect_to :controller => 'users', :action => 'edit_preferences', :id=> @current_user
    when 3
      if @current_user.facebooker_session.user.has_permission? :offline_access
        @current_user.update_attribute(:signup_step, 4)
        # the IF is needed to avoid fake new users notifications for old users
        if @current_user.last_signup_step_at.nil?
          @current_user.update_attribute(:last_signup_step_at, Time.now)
          # add notification
# the following commented out since we notify new users only once they are approved
#          notify_new_user(@current_user)
          notify_new_user_to_administrators(@current_user)
          flash[:notice] = 'Your profile is now complete. Welcome!'
        end
      else
        flash[:notice] = 'One more step to enter.'
        redirect_to :controller => 'users', :action => 'edit_permissions', :id=> @current_user
      end
    end
  end

  def my_30_days_ago_utc
    return Time.now.utc-(1*60*60*24*30) # - 30 days
  end

#  def ensure_have_entered_email_address
#    unless @current_user.nil?
#      if @current_user.signup_step >= 3 && @current_user.email.blank?
#        flash[:notice] = "Your Email address is missing, we need it to communicate with your. Please enter your email address below."
#        #@current_user.errors.add(:email, ": Your Email address is missing, we need it to communicate with your. Please enter your email address below.")
#        redirect_to :controller => :users, :action => :edit_profile, :id => @current_user.id
#      end
#    end
#  end

  def ensure_have_entered_email_address_and_new_profile_data
    unless @current_user.nil?
      if @current_user.signup_step >= 3 && 
          (  @current_user.email.blank? ||
            @current_user.is_board_member.nil? ||
            @current_user.is_boss.nil? ||
            @current_user.is_manager.nil? ||
            @current_user.hours_as_worker.nil? ||
            @current_user.hours_as_volunteer.nil?
          )
        flash[:notice] = "We have upgraded the user profile adding some questions, please update your data by answering all questions marked with (*)"
        redirect_to :controller => :users, :action => :edit_profile, :id => @current_user.id
      end
    end
  end

  def my_one_hour_ago_utc
    return Time.now.utc-(1*60*60) # - 1 hour
  end

  def my_fetch_url(url)
    r = Net::HTTP.get_response( URI.parse( url ) )
    if r.is_a? Net::HTTPSuccess
      r.body
    else
      nil
    end
  end

  def add_notification(message, user=nil)
    if user.nil?
      user_id = nil
    else
      user_id = user.id
    end
    notification = Notification.new(:user_id => user_id, :message => message, :date => Time.now)
    notification.save
    return notification
  end

  # incrementa il contatore a tutti tranne l'utente 'user'
  def increment_count_for_all_users_except(skip_user=nil)
    users = User.find(:all, :conditions => BASE_USER_FIND_CONDITIONS)
    (users = users.delete_if {|x| x.id == skip_user.id}) unless skip_user.nil?
    unless users.empty?
      Facebooker::User.dashboard_multi_increment_count(users.map {|user| user.uid.to_s})
    end
  end

  def increment_count_for_all_users
    increment_count_for_all_users_except
  end

  def increment_count_for_user(user)
    if user.nil?
      increment_count_for_all_users
    else
      Facebooker::User.dashboard_multi_increment_count [user.uid.to_s]
    end
  end

  def notify_new_user(user)
    # aggiungo una notification
    #message = "<a href='http://apps.facebook.com/changingroom-dev/users/#{user.id}'>#{user.cached_name}#{' <img src = '+user.cached_pic_square+' height = 30px >' unless user.cached_pic_square.blank? }</a> from <a href='http://apps.facebook.com/changingroom-dev/organisations/#{user.organisation.id}'>#{user.organisation.short_name}</a> (#{user.organisation.country}) joined the #{APPLICATION_NAME}."
    message = "<a href='#{root_url}users/#{user.id}'>#{user.cached_name}</a><a href='#{root_url}users/#{user.id}'>#{' <img  style="border:0px" src = '+user.cached_pic_square+' height = 30px >' unless user.cached_pic_square.blank? }</a> from <a href='#{root_url}organisations/#{user.organisation.id}'>#{user.organisation.short_name}</a> (#{user.organisation.country}) joined the #{APPLICATION_NAME}."
    added_notification = add_notification(message)
    # incremento il counter di tutti (tranne il nuovo utente)
    increment_count_for_all_users_except(user)
    # add notification to users for which this new user is a match
    # add notification to users for which this new user is a colleague
    add_notification_of_new_collegue(user)
    # send his notifications which has not been read to users which has asked to receive notification asap + last notification for all if he subscribed to
    #object = "#{user.cached_name} joined the MatchMaker"
    #send_asap_email_notifications_to_all_users(added_notification.message, object)
  end

  def notify_new_user_to_administrators(user)
    # aggiungo una notification per gli amministratori
    message = "#{user.cached_name}#{' <img  style="border:0px" src = '+user.cached_pic_square+' height = 30px >' unless user.cached_pic_square.blank? } from <a href='#{root_url}organisations/#{user.organisation.id}'>#{user.organisation.short_name}</a> (#{user.organisation.country}) just joined the #{APPLICATION_NAME} but need the approval of you or another administrator. Please check user a.s.a.p. the <a href='#{root_url}admin/pending_users'>list of users that need to be approved</a>."
    User.find(:all, :conditions => {:is_admin => true}).each do |user|
      add_notification(message, user)
      increment_count_for_user(user)
    end  
  end

  def approve_user_notify_him_and_notify_others(user)
    user.update_attribute(:is_approved, true)
    message = "Hey #{user.cached_name}, <br/> your registration have just been approved! Welcome to the <a href='#{root_url}'>#{APPLICATION_NAME}</a>.  You can now have access to all data. <br/>Thank you for applying, see you in the #{APPLICATION_NAME} at <a href='#{root_url}'>#{root_url}</a>"
    add_notification(message, user)
    notify_new_user(user)
  end

  def add_notification_of_new_collegue(user)
    # add personal notification to colleague, to all colleague that have chosen to be notified
    # the *email* will be sent to them (and this *if* they have chosen to receive notification)
    colleague_users = User.all(:conditions => BASE_USER_FIND_CONDITIONS + " AND job_area = #{user.job_area} AND notify_colleague = true AND id != #{user.id}")
    colleague_users.each do |colleague_user|
      message = "You have a new colleague: new user <a href='#{root_url}users/#{user.id}'>#{user.cached_name}</a><a href='#{root_url}users/#{user.id}'>#{' <img  style="border:0px" src = '+user.cached_pic_square+' height = 30px >' unless user.cached_pic_square.blank? }</a> from <a href='#{root_url}organisations/#{user.organisation.id}'>#{user.organisation.short_name}</a> (#{user.organisation.country}) is working in the same your area (#{colleague_user.job_area_in_words})."
      add_notification(message, colleague_user)
    end
  end

  def notify_new_organisation_post(organisation_post)
    # aggiungo una notification
    #message = "<a href='http://apps.facebook.com/changingroom-dev/organisation_posts/1'>New offer</a> added (area: #{organisation_post.area_in_words})."
    message = "<a href='#{root_url}organisation_posts/#{organisation_post.id}'>New offer</a> added (area: #{organisation_post.area_in_words})."
    add_notification(message)
    # incremento il counter di tutti (proprio tutti)
    increment_count_for_all_users_except()
    # add notification to users for which this offer is a match
    add_notification_of_new_match_offer(organisation_post)
  end

  def add_notification_of_new_match_offer(organisation_post)
    # add personal notification to user for which this offer is a match, to all users that have chosen to be notified
    # the *email* will be sent to them (and this *if* they have chosen to receive notification)
    match_users = User.all(:conditions => BASE_USER_FIND_CONDITIONS + " AND job_area = '#{organisation_post.area}' AND notify_colleague = true")
    match_users.each do |match_user|
      message = "An <a href='#{root_url}organisation_posts/#{organisation_post.id}'>offer</a> match your working area (#{organisation_post.area_in_words}).  In details: <strong>#{organisation_post.organisation.short_name}</strong> (#{organisation_post.organisation.country}) is looking for <strong>#{organisation_post.category}</strong>.  <a href='#{root_url}organisation_posts/#{organisation_post.id}'>View more</a>."
      add_notification(message, match_user)
    end
  end

#  def increment_count_for_user(user)
#    # increment counter
#    #object = 'Notification from the MatchMaker'
#    if user.nil?
#      increment_count_for_all_users
#      #send_asap_email_notifications_to_all_users(notification.message, object)
#    else
#      increment_count_for_user(user)
#      #send_asap_email_notifications_to_user(user, notification.message, object)
#    end
#  end

#  def send_asap_email_notifications_to_all_users(message, object)
#    asap_users = User.all(:conditions => BASE_USER_FIND_CONDITIONS + " AND email IS NOT NULL AND notification_by_email_every= 'asap' AND notify_notifications_for_all = 1")
#    asap_users.each do |user|
#      send_email_notification(user, message, object)
#    end
#  end

#  def send_asap_email_notifications_to_user(user, message, object)
#    send_email_notification(user, message, object)
#  end

  def send_email_notification(user, message, object)
    message = EMAIL_NOTIFICATION_TEXT_TOP + "<p>#{message}</p>" + EMAIL_NOTIFICATION_TEXT_BOTTOM
    unless user.email.blank?
      recipient = user.email
      queue_email(message, recipient, object)
    end
  end

  def queue_email(message, recipient, object, sender=SENDER_EMAIL_FOR_NOTIFICATIONS)
    send_email(message, recipient, object, sender)
  end

  def send_email(message, recipient, object, sender)
    EmailNotification.deliver_generic_email(message, recipient, object, sender)
  end

  private

  # the following to add email error notification
  # see http://www.devarticles.com/c/a/Ruby-on-Rails/Error-Checking-and-Debugging-with-Ruby-on-Rails/
  # excerpted from chapter 15 of the Ruby Cookbook, written by Lucas Carlson and Leonard Richardson (O'Reilly, 2006; ISBN: 0596523696)

  def log_error(exception)
       super
       EmailNotification.deliver_error_message(exception,
         clean_backtrace(exception),
         session.instance_variable_get("@data"),
         params,
         request.env
       )
  end

end



def get_organisation_types
  organisations = Organisation.find(:all)
  organisation_types = Array.new
  organisations.each {|x| organisation_types << [x.name, x.id]}
  return organisation_types
end
# general functions # TODO move these functions inside application
#
#
#def @current_user.is_admin
#  # TODO move to User model
#  # TODO check if uid belongs to group membership insthead (maybe?)
#  # Check if user is friend with app
#  if @current_user.nil?
#    result = false
#  else
#    result = @current_user.is_admin
##      groups_gids = Array.new
##      @current_user.groups.each {|x| groups_gids << x.gid }
##      result = groups_gids.include?(ADMIN_GROUP_GID.to_i)
#  end
#  return result
#end

# How to find user's friends that have installed this app?  see
# http://rubyforge.org/pipermail/facebooker-talk/2009-February/001546.html

#  def current_user_have_answered_initial_questions?
#    user = session[:current_user]
#    if user.hosting.blank? || user.job_area.blank? || user.job_role.blank? || user.infopoint.blank?
#      return false
#    else
#      return true
#    end
#  end

#  def get_possible_fb_groups_for_current_user
#      possible_groups_gids = Array.new
#      groups_gids = Array.new
#      @current_user.facebooker_session.user.groups.each {|x| groups_gids << x.gid.to_i }
#      groups = Group.find(:all)
#      for group in groups do
#        possible_groups_gids << group.gid if groups_gids.include?(group.gid)
#      end
#      return possible_groups_gids
#  end

#  def get_possible_groups_for_user_types
#    possible_groups_for_user_types = Array.new
#    groups = Group.find(:all)
#    groups_gids = Array.new
#    groups.each {|x| groups_gids << x.gid.to_i }
#    # occhio che nel seguente andiamo a cercare i gruppi dell'utente... in facebook e non nel modello
#    @current_user.facebooker_session.user.groups.each {|x| possible_groups_for_user_types << [x.name+' ('+Group.find_by_gid(x.gid).organisation.short_name+')', Group.find_by_gid(x.gid).id] if groups_gids.include?(x.gid)}
#    # get_possible_groups_for_user.each {|x| possible_groups_for_user_types << [x,Group.find_by_gid(x).id]}
#    return possible_groups_for_user_types
#  end

def we_can_show_the_menu
  # usiamo questa per nascondere il menu in fase di registrazione
  if @current_user.organisation.nil? || # non mostro il menu durante la richiesta delle sua org
       @current_user.signup_step < 4 ||   # o al passo 3 per gli individui
       @current_user.is_pending
    return false
  else
    return true
  end
end



def search_organisations_with (searching_user = nil, options ={})
  #chiamata search_organisations_with(user, :filter => 'all', :country => 'italy'...)
  #
  #
  # porto tutti i valori a blank
  filter              = options[:filter].to_s.strip
  country             = options[:country].to_s.strip
  distance            = options[:distance].to_f # 0.0 if nil
  location            = options[:location] # is a Geokit::location
  location_lat        = options[:location_lat].to_f
  location_lng        = options[:location_lng].to_f
  searching_user_id   = options[:searching_user_id].to_i
  # controllo coerenza location
  unless (location && location.class == Geokit::GeoLoc && location.success)
    location = nil
    unless location_lat == 0 || location_lng == 0
      location = Geokit::GeoLoc.new
      location.lat = location_lat
      location.lng = location_lng
    end
  end
  #get searching_user
  searching_user = searching_user || @current_user
  if !searching_user && searching_user_id
    searching_user = User.find_by_id(searching_user_id)
  end
  #
  #
  # FILTER
  #
  if filter ==  'all' || filter.blank?
    organisations = OrganisationPost.find(:all,
                      :conditions => BASE_ORGANISATION_FIND_CONDITIONS )

  elsif filter == 'my_organisation'
    organisations = OrganisationPost.find(:all,
                      :conditions => BASE_ORGANISATION_FIND_CONDITIONS+' AND '+
                                      "(organisation_id = '#{searching_user.organisation.id}')")

#  elsif filter == 'recently_added'
#    organisations = OrganisationPost.find(:all, :order => 'created_at DESC', :conditions => BASE_ORGANISATION_FIND_CONDITIONS)
#    #users.sort! { |user,another_user| user.country <=> another_user.country }
#    #users.sort_by { |user| user.country }

  else
    flash[:error] = 'Filter Error', "Filter '#{filter}' not yet implemented"
    return
  end

  # ADVANCED
  #
  unless country.blank? || organisations.empty?
    organisations.delete_if { |organisation| organisation.organisation.country != country }
  end

  # se distance == 0 significa che prendo tutti gli elementi a prescindere dalla distanza
  unless location.nil? || distance == 0 || organisations.empty?
        organisations.delete_if { |organisation| organisation.organisation.distance_from(location) > distance }
  end
  #
  return organisations

end

def search_organisation_posts_with (searching_user = nil, options ={})
  #chiamata search_organisation_posts_with(user, :filter => 'all', :country => 'italy'...)
  #
  #
  # porto tutti i valori a blank
  filter              = options[:filter].to_s.strip
  country             = options[:country].to_s.strip
  organisation        = options[:organisation].to_s.strip
  area                = options[:area].to_s.strip
  category            = options[:category].to_s.strip
  duration            = options[:duration].to_i
  distance            = options[:distance].to_f # 0.0 if nil
  location            = options[:location] # is a Geokit::location
  location_lat        = options[:location_lat].to_f
  location_lng        = options[:location_lng].to_f
  searching_user_id   = options[:searching_user_id].to_i
  # controllo coerenza location
  unless (location && location.class == Geokit::GeoLoc && location.success)
    location = nil
    unless location_lat == 0 || location_lng == 0
      location = Geokit::GeoLoc.new
      location.lat = location_lat
      location.lng = location_lng
    end
  end
  #get searching_user
  searching_user = searching_user || @current_user
  if !searching_user && searching_user_id
    searching_user = User.find_by_id(searching_user_id)
  end
  #
  #
  # FILTER
  #
  if filter ==  'all' || filter.blank?
    organisation_posts = OrganisationPost.find(:all,
                      :conditions => BASE_ORGANISATION_POST_FIND_CONDITIONS )

  elsif filter == 'my_organisation'
    organisation_posts = OrganisationPost.find(:all,
                      :conditions => BASE_ORGANISATION_POST_FIND_CONDITIONS+' AND '+
                                      "(organisation_id = '#{searching_user.organisation.id}')")

#  elsif filter == 'recently_added'
#    organisation_posts = OrganisationPost.find(:all, :order => 'created_at DESC', :conditions => BASE_ORGANISATION_POST_FIND_CONDITIONS)
#    #users.sort! { |user,another_user| user.country <=> another_user.country }
#    #users.sort_by { |user| user.country }

  elsif filter == 'same_job_area'  && searching_user
    organisation_posts = OrganisationPost.find(:all,
                      :conditions => BASE_ORGANISATION_POST_FIND_CONDITIONS+' AND '+
                                      "(area = '#{searching_user.job_area}')")

  else
    flash[:error] = 'Filter Error', "Filter '#{filter}' not yet implemented"
    return
  end

  # ADVANCED
  #
  unless country.blank? || organisation_posts.empty?
    organisation_posts.delete_if { |organisation_post| organisation_post.organisation.country != country }
  end
  unless organisation.blank? || organisation_posts.empty?
    organisation_posts.delete_if { |organisation_post| organisation_post.organisation.id != organisation.to_i }
  end
  unless area.blank? || organisation_posts.empty?
    organisation_posts.delete_if { |organisation_post| organisation_post.area != area }
  end
  unless category.blank? || organisation_posts.empty?
    organisation_posts.delete_if { |organisation_post| organisation_post.category != category }
  end
  unless duration == 0 || organisation_posts.empty?
    organisation_posts.delete_if { |organisation_post| organisation_post.duration > duration }
  end
  # se distance == 0 significa che prendo tutti gli elementi a prescindere dalla distanza
  unless location.nil? || distance == 0 || organisation_posts.empty?
        organisation_posts.delete_if { |organisation_post| organisation_post.organisation.distance_from(location) > distance }
  end
  #
  return organisation_posts
end

def search_users_with (searching_user = nil, options ={})
  #chiamata search_users_with(user, :filter => 'all', :country => 'italy'...)
  #
  #
  # porto tutti i valori a blank
  filter              = options[:filter].to_s.strip
  country             = options[:country].to_s.strip
  organisation        = options[:organisation].to_s.strip
  gender              = options[:gender].to_s.strip
  go_as               = options[:go_as].to_s.strip
  distance            = options[:distance].to_f # 0.0 if nil
  location            = options[:location] # is a Geokit::location
  location_lat        = options[:location_lat].to_f
  location_lng        = options[:location_lng].to_f
  searching_user_id   = options[:searching_user_id].to_i
  job_area            = options[:job_area].to_s.strip
  job_role            = options[:job_role].to_s.strip
  friendship          = options[:friendship].to_s.strip
  name                = options[:name].to_s.strip.downcase
  
  # controllo coerenza location
  # ovvero devo avere sicuramente location ke sia un Geokit::GeoLoc
  unless (location && location.class == Geokit::GeoLoc && location.success)
    location = nil
    unless location_lat == 0 || location_lng == 0
      location = Geokit::GeoLoc.new
      location.lat = location_lat
      location.lng = location_lng
    end
  end
  #get searching_user
  searching_user = searching_user || @current_user
  if !searching_user && searching_user_id
    searching_user = User.find_by_id(searching_user_id)
  end
  #
  #
  # FILTER
  #
  if filter ==  'all' || filter.blank?
    users = User.find(:all,
                      :conditions => BASE_USER_FIND_CONDITIONS )

  elsif filter == 'my_organisation'
    users = User.find(:all,
                      :conditions => BASE_USER_FIND_CONDITIONS+' AND '+
                                      "(organisation_id = '#{searching_user.organisation.id}')")

#  elsif filter == 'recently_added'
#    users = User.find(:all, :order => 'created_at DESC', :conditions => BASE_USER_FIND_CONDITIONS)
#    #users.sort! { |user,another_user| user.country <=> another_user.country }
#    #users.sort_by { |user| user.country }

  elsif filter == 'hosting'
    users = User.find(:all,
                      :conditions => BASE_USER_FIND_CONDITIONS+' AND '+
                                      "(hosting <> 'no')")
  elsif filter == 'volunteers'
    users = User.find(:all,
                      :conditions => BASE_USER_FIND_CONDITIONS+' AND '+
                                      "(go_as_volunteer > 0)")
  elsif filter == 'interns'
    users = User.find(:all,
                      :conditions => BASE_USER_FIND_CONDITIONS+' AND '+
                                      "(go_as_intern > 0)")
  elsif filter == 'workers'
    users = User.find(:all,
                      :conditions => BASE_USER_FIND_CONDITIONS+' AND '+
                                      "(go_as_worker > 0)")
  elsif filter == 'visitors'
    users = User.find(:all,
                      :conditions => BASE_USER_FIND_CONDITIONS+' AND '+
                                      "(go_as_visitor > 0)")
  elsif filter == 'same_job_area'  && searching_user
    users = User.find(:all,
                      :conditions => BASE_USER_FIND_CONDITIONS+' AND '+
                                      "(job_area = '#{searching_user.job_area}')")

  elsif filter == 'same_job_role'  && searching_user
    users = User.find(:all,
                      :conditions => BASE_USER_FIND_CONDITIONS+' AND '+
                                      "(job_role = '#{searching_user.job_role}')")
  elsif filter == 'same_job_area_and_role' && searching_user
    users = User.find(:all,
                      :conditions => BASE_USER_FIND_CONDITIONS+' AND '+
                                      "(job_role = '#{searching_user.job_role}') AND "+
                                      "(job_area = '#{searching_user.job_area}')")
  else
    flash[:error] = 'Filter Error', "Filter '#{filter}' not yet implemented"
    return
  end

  # ADVANCED
  #
  unless country.blank? || users.empty?
    users.delete_if { |user| user.country != country }
  end
  unless organisation.blank? || users.empty?
    users.delete_if { |user| user.organisation.id != organisation.to_i }
  end
  unless gender.blank? || users.empty?
    users.delete_if { |user| user.gender != gender }
  end
  unless go_as.blank? || users.empty?
    case go_as
    when 'worker'
      users.delete_if { |user| user.go_as_worker == 0 }
    when 'volunteer'
      users.delete_if { |user| user.go_as_volunteer == 0 }
    when 'intern'
      users.delete_if { |user| user.go_as_intern == 0 }
    when 'visitor'
      users.delete_if { |user| user.go_as_visitor == 0 }
    else
      flash[:error] = 'Search Error', "Search criteria '#{go_as}' not yet implemented"
      return
    end
  end
  # se distance == 0 significa che prendo tutti gli elementi a prescindere dalla distanza
  unless location.nil? || distance == 0 || users.empty?
        users.delete_if { |user| user.distance_from(location) > distance }
  end
  unless job_area.blank? || users.empty?
    users.delete_if { |user| user.job_area != job_area }
  end
  unless job_role.blank? || users.empty?
    users.delete_if { |user| user.job_role != job_role }
  end
  #
  # friendship
  unless friendship.blank? || users.empty? || @current_user != searching_user
    if friendship == 'friends'
      # se uso la seguente ESCLUDO gli amici che sono ancora tali pure avento tolto l'autorizzazione all'applicazione
      # (che non si sono tuttavia ancora cancellati dal MM)
      # current_user_friend_uids = @current_user.facebooker_session.user.friend_ids_with_this_app
      friend_uids = @current_user.facebooker_session.user.friend_ids
      users.delete_if { |user| !(friend_uids.include? user.uid.to_s) }
    elsif friendship == 'non-friends'
      friend_uids = @current_user.facebooker_session.user.friend_ids
      users.delete_if { |user| friend_uids.include? user.uid.to_s }
    elsif friendship == 'fof'
      friend_uids = @current_user.facebooker_session.user.friend_ids_with_this_app
#      fof_uids = []
#      @current_user.facebooker_session.user.friends_with_this_app.each do |friend|
#        fof_uids += friend.friend_ids_with_this_app
#      end
#      friends_and_fof_uids = (friend_uids + fof_uids).uniq
#      users.delete_if { |user| !(friends_and_fof_uids.include? user.uid.to_s) }
      #friend_uids = friend_uids.map {|x| x.to_s}
      users.delete_if do |user|                           # butto se
            (!friend_uids.include? user.uid.to_s)  &&        # non è mio amico Ev(PARENTESI!!!!!!!!!!)
            ((user.facebook_friend_uids & friend_uids).size == 0) # ha amici in comune con current_user
      end
      #
    end
  end

  unless name.blank? || users.empty?
    users.delete_if { |user| !user.cached_name.downcase.include?(name) }
  end
  
  #
  return users
end


def search_organisations_with (searching_user = nil, options ={})
  #chiamata search_organisations_with(organisation, :filter => 'all', :country => 'italy'...)
  #
  #
  # porto tutti i valori a blank
  filter              = options[:filter].to_s.strip
  country             = options[:country].to_s.strip
  distance            = options[:distance].to_f # 0.0 if nil
  location            = options[:location] # is a Geokit::location
  location_lat        = options[:location_lat].to_f
  location_lng        = options[:location_lng].to_f
  searching_user_id   = options[:searching_user_id].to_i
  organisation_id     = options[:organisation].to_i
  name                = options[:name].to_s.strip.downcase
  # controllo coerenza location
  # ovvero devo avere sicuramente location ke sia un Geokit::GeoLoc
  unless (location && location.class == Geokit::GeoLoc && location.success)
    location = nil
    unless location_lat == 0 || location_lng == 0
      location = Geokit::GeoLoc.new
      location.lat = location_lat
      location.lng = location_lng
    end
  end
  #get searching_user
  searching_user = searching_user || @current_user
  if !searching_user && searching_user_id
    searching_user = User.find_by_id(searching_user_id)
  end
  #
  #
  # FILTER
  #
  if filter ==  'all' || filter.blank?
    organisations = Organisation.find(:all,
                      :conditions => BASE_ORGANISATION_FIND_CONDITIONS )

  elsif filter == 'members'
    organisations = Organisation.find(:all,
                      :conditions => BASE_ORGANISATION_FIND_CONDITIONS+" AND (teh_membership = 'member')" )

  elsif filter == 'recently_added'
    organisations = Organisation.find(:all, :order => 'created_at DESC', :conditions => BASE_ORGANISATION_FIND_CONDITIONS)
    #organisations.sort! { |organisation,another_organisation| organisation.country <=> another_organisation.country }
    #organisations.sort_by { |organisation| organisation.country }
  else
    flash[:error] = 'Filter Error', "Filter '#{filter}' not yet implemented"
    return
  end

  # ADVANCED
  #
  unless country.blank? || organisations.empty?
    organisations.delete_if { |organisation| organisation.country != country }
  end

  unless organisation_id==0|| organisations.empty?
    organisations.delete_if { |organisation| organisation.id != organisation_id }
  end

  # se distance == 0 significa che prendo tutti gli elementi a prescindere dalla distanza
  unless location.nil? || distance == 0 || organisations.empty?
        organisations.delete_if { |organisation| organisation.distance_from(location) > distance }
  end
 
  unless name.blank? || organisations.empty?
    organisations.delete_if { |organisation| !organisation.name.downcase.include?(name) &&  !organisation.short_name.downcase.include?(name)}
  end

  #
  return organisations
end

# the following moved to config/environment.rb
#def remove_eventual_http(link)
#  cleaned_link = link.to_s.strip
#  cleaned_link = cleaned_link[0,7] != "http://" ? cleaned_link : cleaned_link[7,cleaned_link.length]
#  cleaned_link = cleaned_link[0,6] != "http//" ?  cleaned_link : cleaned_link[6,cleaned_link.length]
#  cleaned_link = cleaned_link[0,6] != "http:/" ?  cleaned_link : cleaned_link[6,cleaned_link.length]
#  return cleaned_link
#end
