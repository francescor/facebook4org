class NotificationsController < ApplicationController
  layout 'main'
  # GET /notifications
  # GET /notifications.xml
  def index
    notifications_for_all = Notification.all(:conditions => {:user_id => nil}).sort
    if params['user_id'].blank?
      @notifications = notifications_for_all
      @selected_options =  ''
    else
      @user = User.find(params['user_id'] || @current_user.id)
      @selected_options =  @user.id
      @notifications = @user.notifications      
    end
    @options_for_select = User.find(:all, :conditions => BASE_USER_FIND_CONDITIONS).map {|user| [ "#{user.cached_name} #{'('+user.notifications.size.to_s+')' if user.notifications.size>0}", user.id ] }
    @options_for_select_with_all = [["All users (#{notifications_for_all.size})",nil]]+@options_for_select
    respond_to do |format|
      format.fbml # index.html.erb
    end
  end

  # GET /notifications/1
  # GET /notifications/1.xml
  def show
    @notification = Notification.find(params[:id])
    user_id = @notification.user.id unless @notification.user.nil?
    redirect_to(:action => "index", :user_id => user_id)
    #respond_to do |format|
    #  format.fbml # show.html.erb
    #end
  end

  # GET /notifications/new
  # GET /notifications/new.xml
  def new
    @options_for_select_with_all =  [["All users",nil]]+User.find(:all, :conditions => BASE_USER_FIND_CONDITIONS).map {|user| [ user.cached_name, user.id ] }
    @notification = Notification.new
    @notification.user_id = params[:user_id].to_i unless params[:user_id].nil?
    respond_to do |format|
      format.fbml # new.html.erb
    end
  end

  # GET /notifications/1/edit
  def edit
    @options_for_select_with_all = [["All users",nil]]+User.find(:all, :conditions => BASE_USER_FIND_CONDITIONS).map {|user| [ user.cached_name, user.id ] }
    @notification = Notification.find(params[:id])
  end

  # POST /notifications
  # POST /notifications.xml
  def create
    @notification = Notification.new(params[:notification])

    respond_to do |format|
      if @notification.save
        # notify: increment counter 
        increment_count_for_user(@notification.user)
        #
        if @notification.user.nil?
          user_id =''
          notice = "Notification created. All users' dasboards counters incremented, and email notification sent to users (depending on their preferences: asap, dayly, weekly, monthly, never)"
        else
          user_id = @notification.user.id
          notice = "Notification created. #{@notification.user.cached_name}'s dasboard counter incremented and email notification sent if user have choose so"
        end
        format.fbml { redirect_to(:action => "index", :notice => notice, :user_id => user_id) }
      else
        format.fbml { render :action => "new" }
      end
    end
  end

  # PUT /notifications/1
  # PUT /notifications/1.xml
  def update
    @notification = Notification.find(params[:id])

    respond_to do |format|
      if @notification.update_attributes(params[:notification])
        user_id = @notification.user.id unless @notification.user.nil?
        format.fbml { redirect_to(:action => "index", :notice => 'Notification was successfully updated.', :user_id => user_id) }
      else
        format.fbml { render :action => "index" }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.xml
  def destroy
    @notification = Notification.find(params[:id])
    user_id = @notification.user.id unless @notification.user.nil?
    @notification.destroy

    respond_to do |format|
      #format.fbml { redirect_to(notifications_url) }
      format.fbml { redirect_to(:action => "index", :notice => 'Notification was successfully updated.', :user_id => user_id) }
    end
  end
end
