class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  layout 'main'

  skip_before_filter  :ensure_user_have_signup_with_all_step,
                      :except => [:show, :index]
  skip_before_filter  :ensure_have_entered_email_address_and_new_profile_data,
                      :except => [:show, :index, :edit_preferences, :edit_notification_preferences, :edit_permissions]
  skip_before_filter  :ensure_user_is_approved,
                      # elenco azioni in cui FARE il controllo
                      :except => [:index, :show]

  def index
    redirect_to search_url(:template => 'basic', :output => 'list', :clear_session => 'true')
    #@users = User.all
#    @users = User.find(:all, :conditions => STANDARD_INDIVIDUAL_USER_FIND_CONDITIONS , :order => 'country ASC')
#    respond_to do |format|
#      format.fbml # index.html.erb
#      format.xml  { render :xml => @users }
#    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    #@user = User.find(params[:id])
    @user = User.first(:conditions=> {:id => params[:id]})
    if @user.nil?
      flash[:notice] = 'Oops. The user you are searching is not here anymore.'
      redirect_to search_url(:output => 'list', :reset => 'all', :show_quick_search => 'yes', :template => 'basic' )
    else
      #@user.increment_view_counter unless @user == @current_user
      # if cached data is empty, we get it :)

      # this is for contact form
      @contact = Contact.new

      @app_user = @user.facebook_app_user
      @current_user_friend_uids = params[:fb_sig_friends].split(',')

      if @app_user.nil?
        @friend_uids = []
      elsif @user == @current_user
        @friend_uids = @current_user_friend_uids
      else
        @friend_uids = @app_user.friend_ids
        # @friend_uids = @user.facebook_friend_uids_seen_from_current_user(@current_user)
      end


      @all_MM_user_uids = User.find(:all, :conditions => BASE_USER_FIND_CONDITIONS).map{|user| user.uid.to_s }
      #
      # @friend_uids_in_common_with_current_user           =  @user.facebook_friend_uids_in_common_with_current_user(@current_user)
      @friend_uids_in_common_with_current_user           = @friend_uids & @current_user_friend_uids
      @friend_uids_in_common_with_current_user_in_MM     = @friend_uids_in_common_with_current_user & @all_MM_user_uids
      @friend_uids_in_common_with_current_user_not_in_MM = @friend_uids_in_common_with_current_user - @friend_uids_in_common_with_current_user_in_MM
      #
     # @friend_uids = @user.facebook_friend_uids_seen_from_current_user(@current_user)
      @friend_uids_in_MM     = @friend_uids & @all_MM_user_uids
      @friend_uids_not_in_MM = @friend_uids - @friend_uids_in_MM
      #
      @friend_uids_in_MM_without_common     = @friend_uids_in_MM     - @friend_uids_in_common_with_current_user - [@current_user.uid.to_s]
      @friend_uids_not_in_MM_without_common = @friend_uids_not_in_MM - @friend_uids_in_common_with_current_user

      #
      @url_for_iframe = FACEBOOKER['callback_url'] + "/iframe/iframe_user_map?"+
                                   "user_id=#{@user.id}&"+
                                   "searching_user_id=#{@current_user.id}"
      #
      # if cached data is empty, we get it :)
      if (@user.cached_name.blank? || @user.cached_pic_square.blank? || @user.cached_profile_url.blank?)
        fb_user_array = @current_user.facebooker_session.users([@user.uid], [:name,:profile_url,:pic_square])
        unless fb_user_array.nil?
          fb_user = fb_user_array[0]
          @user.cached_name = fb_user.name if @user.cached_name.blank?
          @user.cached_pic_square = fb_user.pic_square if @user.cached_pic_square.blank?
          @user.cached_profile_url = fb_user.profile_url if @user.cached_profile_url.blank?
          @user.save_with_validation(false)
        end
      end
      respond_to do |format|
        format.fbml # show.html.erb
  #      format.xml  { render :xml => @user }
      end
    end
  end

  # GET /users/new
  # GET /users/new.xml
#  def new
#    @user = User.new
#
#    respond_to do |format|
#      format.fbml # new.html.erb
#      format.xml  { render :xml => @user }
#    end
#  end


#  def select_org
#         organisations = Organisation.find(:all, :order => 'short_name ASC')
#         @organisations_type = organisations.map {|x| [x.short_name, x.id]}
#         #@organisations_type = @organisations_type.sort_by {|array_item| array_item[0]}
#  end

  # GET /users/1/edit_profile
  def edit_profile
    @user = User.find(params[:id] || @current_user.id)
    unless @current_user == @user || @current_user.is_admin
      redirect_to :controller => :main
    end
  end

  # GET /users/1/edit_preferences
  def edit_preferences
    @user = User.find(params[:id] || @current_user.id)
    unless @current_user == @user || @current_user.is_admin
      redirect_to :controller => :main
    end
  end
  # GET /users/1/edit_notification_preferences
  def edit_notification_preferences
    @user = User.find(params[:id] || @current_user.id)
    unless @current_user == @user || @current_user.is_admin
      redirect_to :controller => :main
    end
  end

    # GET /users/1/edit_permissions
  def edit_permissions
    #
    # we arrive here only if the permission is not given and the signup_step is 3
    # 
    # this page is ONLY for current user, of course
    #@user_has_permission_for_email = @current_user.facebooker_session.user.has_permission? :email
    #@user_has_permission_for_offline_access = @current_user.facebooker_session.user.has_permission? :offline_access
    #@current_user.has_permissions? [:offline_access, :email]
  end


#  # GET /users/1/edit
#  def edit
#    @user = User.find(params[:id])
#  end

  # POST /users
  # POST /users.xml
#  def create
#    @user = User.new(params[:user])
#
#    respond_to do |format|
#      if @user.save
#        flash[:notice] = 'User was successfully created.'
#        format.fbml { redirect_to(@user) }
#        format.xml  { render :xml => @user, :status => :created, :location => @user }
#      else
#        format.fbml { render :action => "new" }
#        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    unless @current_user == @user || @current_user.is_admin
      flash[:error] = 'Permission Error', 'Only administrators can update user profile different from their own.'
      redirect_to :controller => :main
    end
    respond_to do |format|
      address_has_changed = true   if params[:user][:city]      != @user.city ||
                                      params[:user][:post_code] != @user.post_code ||
                                      params[:user][:state]     != @user.state ||
                                      params[:user][:country]   != @user.country ||
                                      params[:user][:street]    != @user.street
      if @user.update_attributes(params[:user])
        # now that we have passed validation
        @user.update_user_geo_info if address_has_changed
#        if params['edit_action'] == 'select_org'
#          # NUOVO
#          @current_user.save_with_validation(false)
#          set_default_profile_for_current_user # so @user.signup_step => 1
#          format.fbml { redirect_to(:controller => 'users', :action => 'edit_profile') }
        if (@user.signup_step == 1 && params['edit_action'] == 'edit_profile')
          # now we have the address and we can update geo info
          @user.update_attribute(:signup_step, 2)
          flash[:notice] = 'Thank you for entering your information. Now tell us about your mobility preferences.'
          format.fbml { redirect_to(:controller => 'users', :action => 'edit_preferences') }
        elsif (@user.signup_step == 2 && params['edit_action'] == 'edit_preferences')
          @user.update_attribute(:signup_step, 3)
          #@user.update_attribute(:last_signup_step_at, Time.now)
          flash[:notice] = 'Well done.'
          # add notification
          # notify_new_user(@user)
          #format.fbml { redirect_to(:controller => 'main', :action => 'index_for_new_users') }
          #format.fbml { redirect_to(:controller => 'users', :action => 'edit_permissions') }
          format.fbml { redirect_to(:controller => 'main', :action => 'index') }
          # nb. il redirect su edit_permission viene fatto nell'application controller
        elsif (@user.signup_step == 3 && params['edit_action'] == 'edit_permissions')
          #
          # attenzione: l'aggiornamento di signup_step si fa in application_controller
          #
#          @user.update_attribute(:signup_step, 4)
          # the IF is needed to evoid fake new users notifications for old users
#          if @user.last_signup_step_at.nil?
#            @user.update_attribute(:last_signup_step_at, Time.now)
#            # add notification
#            notify_new_user(@user)
#          end
#          flash[:notice] = 'Your profile is now complete. Welcome!'
          #format.fbml { redirect_to(:controller => 'main', :action => 'index_for_new_users') }
          format.fbml { redirect_to(:controller => 'main', :action => 'index') }
        else
          # format.fbml { redirect_to(@user) }
          flash[:notice] = 'Data updated.'
          format.fbml { redirect_to(:controller => 'main', :action => 'settings' ) }
        end
      else
        if (@user.signup_step == 2 && params['edit_action'] == 'edit_profile')
          # user has hitted BACK while already at edit_preferences....
          # we reset his signup step
          @user.update_attribute(:signup_step, 1)
          format.fbml { redirect_to(:controller => 'users', :action => 'edit_profile') }
        else
          #format.fbml { render :action => "edit" }
          format.fbml { render :action => params[:edit_action] }
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    if @current_user == @user  # occhio all'ordine, visto ke  anche gli admin si possono voler cancellare
      @user.destroy
      flash[:notice] = 'All your data has been removed.'
      redirect_to root_url
    elsif    @current_user.is_admin
      @user.destroy
      flash[:notice] = 'User removed.'
      redirect_to :controller => 'admin'
    else
      flash[:error] = 'Permission Error', 'Only administrators can delete users.'
      redirect_to :controller => :main
    end
  end
end
