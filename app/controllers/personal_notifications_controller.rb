class PersonalNotificationsController < ApplicationController
  layout 'main'
  # GET /personal_notifications
  # GET /personal_notifications.xml
  def index
    @user = User.find(params['user_id'] || @current_user.id)
    @options_for_select = User.find(:all, :conditions => BASE_USER_FIND_CONDITIONS).map {|user| [ "#{user.cached_name} #{'('+user.personal_notifications.size.to_s+')' if user.personal_notifications.size>0}", user.id ] }
    @personal_notifications = @user.personal_notifications
    respond_to do |format|
      format.fbml # index.html.erb
    end
  end

  # GET /personal_notifications/1
  # GET /personal_notifications/1.xml
  def show
    @personal_notification = PersonalNotification.find(params[:id])

    respond_to do |format|
      format.fbml # show.html.erb
    end
  end

  # GET /personal_notifications/new
  # GET /personal_notifications/new.xml
  def new
    @options_for_select = User.find(:all, :conditions => BASE_USER_FIND_CONDITIONS).map {|user| [ user.cached_name, user.id ] }
    @personal_notification = PersonalNotification.new

    respond_to do |format|
      format.fbml # new.html.erb
    end
  end

  # GET /personal_notifications/1/edit
  def edit
    @options_for_select = User.find(:all, :conditions => BASE_USER_FIND_CONDITIONS).map {|user| [ user.cached_name, user.id ] }
    @personal_notification = PersonalNotification.find(params[:id])
  end

  # POST /personal_notifications
  # POST /personal_notifications.xml
  def create
    @personal_notification = PersonalNotification.new(params[:personal_notification])

    respond_to do |format|
      if @personal_notification.save
        # increment count for this specific user
        increment_count_for_user(@personal_notification.user)
        format.fbml { redirect_to(:action => "index", :notice => 'PersonalNotification was successfully created.') }
      else
        format.fbml { render :action => "new" }
      end
    end
  end

  # PUT /personal_notifications/1
  # PUT /personal_notifications/1.xml
  def update
    @personal_notification = PersonalNotification.find(params[:id])

    respond_to do |format|
      if @personal_notification.update_attributes(params[:personal_notification])
        format.fbml { redirect_to(:action => "index", :notice => 'PersonalNotification was successfully updated.') }
      else
        format.fbml { render :action => "index" }
      end
    end
  end

  # DELETE /personal_notifications/1
  # DELETE /personal_notifications/1.xml
  def destroy
    @personal_notification = PersonalNotification.find(params[:id])
    @personal_notification.destroy

    respond_to do |format|
      format.fbml { redirect_to(personal_notifications_url) }
    end
  end
end
