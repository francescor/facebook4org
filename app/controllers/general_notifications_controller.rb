class GeneralNotificationsController < ApplicationController
  layout 'main'
  before_filter :ensure_is_admin
  # GET /general_notifications
  # GET /general_notifications.xml
  def index
    @general_notifications = GeneralNotification.all(:order => 'date DESC')

    respond_to do |format|
      format.fbml # index.html.erb
    end
  end

  # GET /general_notifications/1
  # GET /general_notifications/1.xml
  def show
    @general_notification = GeneralNotification.find(params[:id])

    respond_to do |format|
      format.fbml # show.html.erb
    end
  end

  # GET /general_notifications/new
  # GET /general_notifications/new.xml
  def new
    @general_notification = GeneralNotification.new

    respond_to do |format|
      format.fbml # new.html.erb
    end
  end

  # GET /general_notifications/1/edit
  def edit
    @general_notification = GeneralNotification.find(params[:id])
  end

  # POST /general_notifications
  # POST /general_notifications.xml
  def create
    @general_notification = GeneralNotification.new(params[:general_notification])

    respond_to do |format|
      if @general_notification.save
        # increment count for all users
        increment_count_for_all_users_except()
        format.fbml { redirect_to(:action => "index", :notice => 'GeneralNotification was successfully created.') }
      else
        format.fbml { render :action => "new" }
      end
    end
  end

  # PUT /general_notifications/1
  # PUT /general_notifications/1.xml
  def update
    @general_notification = GeneralNotification.find(params[:id])

    respond_to do |format|
      if @general_notification.update_attributes(params[:general_notification])
        format.fbml { redirect_to(:action => "index", :notice => 'GeneralNotification was successfully updated.') }
      else
        format.fbml { render :action => "index" }
      end
    end
  end

  # DELETE /general_notifications/1
  # DELETE /general_notifications/1.xml
  def destroy
    @general_notification = GeneralNotification.find(params[:id])
    @general_notification.destroy

    respond_to do |format|
      format.fbml { redirect_to(general_notifications_url) }
    end
  end
end
