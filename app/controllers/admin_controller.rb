class AdminController < ApplicationController
  layout 'main'
  before_filter :ensure_is_admin

  def index
  end

  def statistics
    @my_30_days_ago_utc = my_30_days_ago_utc
    @users = User.find(:all, :conditions => BASE_USER_FIND_CONDITIONS)
    @total_users = @users.size
    @organisations = Organisation.find(:all)
    @organisations_by_users = @organisations.map {|organisation| [organisation.name, User.find(:all, :conditions => "organisation_id = #{organisation.id} AND (signup_step >= 3)").size]}
    @organisations_by_users.sort!{|x,y| x[1] <=> y[1]}.reverse!
  end

  def users_list
    order = params[:order] || 'signup_step'
    @users = User.find(:all, :order => "#{order} DESC")
    # Facebooker::User.dashboard_multi_get_count ['757428004', '688296270']
    @counter_hash = Facebooker::User.dashboard_multi_get_count @users.map{|user| user.uid.to_s}
    # counter_hash = {"757428004"=>"0", "688296270"=>"14"}
    # now, counter_hash["757428004"] = 0

  end

  def pending_users
#    @users = User.find(:all, :conditions => {:is_approved => false})
    @users = User.find(:all, :conditions => "is_approved = false AND signup_step >=4 ")
  end

  def bulk_approve
    users = User.find(:all, :conditions => {:is_approved => false, :signup_step => 4})
    users.each do |user|
      user.update_attribute(:is_approved, true)
    end
    flash[:notice] = "Successfully approved #{users.size} users."
    redirect_to :action => :pending_users
  end

  def approve_user
    user_id = params[:user_id].to_i
    user = User.find_by_id(user_id)
    if user
      approve_user_notify_him_and_notify_others(user)
      flash[:notice] = "Successfully approved #{user.cached_name}."
    else
      flash[:error] = "Something went wrong. Cannot find user with id #{user_id}."
    end
    redirect_to :action => :pending_users
  end

  def cron
    #@users_with_empty_lat_and_lng = User.find_all_by_lat_and_lng(0,0)
    #@users_with_empty_lat_and_lng = User.find(:all, :conditions => {:lat => 0, :lng => 0, :signup_step => 3})
    @users_with_empty_lat_and_lng = User.find(:all, :conditions => "signup_step >= 3 AND lat = 0 AND lng = 0")
    @organisations_with_empty_lat_and_lng = Organisation.find(:all, :conditions => "lat = 0 AND lng = 0")

  end

  def populate_users_lat_and_lng
    @users_with_empty_lat_and_lng = User.find_all_by_lat_and_lng(0,0)
    counter = 0
    @users_with_empty_lat_and_lng.each do |user|
      address = ''
      address += "#{user.city}, " unless user.city.blank?
      address += "#{user.state}, " unless user.state.blank?
      address += "#{user.post_code}, " unless user.post_code.blank?
      address += "#{user.country}, " unless user.country.blank?
      #
      unless address.blank?
        loc = MultiGeocoder.geocode(address)
        if loc.success
          user.lat = loc.lat
          user.lng = loc.lng
          user.save
          counter += 1
        end
      end
    end
    if counter > 0
      flash[:notice] = "Successfully updated #{counter} locations"
    else
      flash[:notice] = "no updates"
    end
    redirect_to :action => 'cron'
  end

  def populate_organisations_lat_and_lng
    @organisations_with_empty_lat_and_lng = Organisation.find_all_by_lat_and_lng(0,0)
    counter = 0
    @organisations_with_empty_lat_and_lng.each do |organisation|
      address = ''
      address += "#{organisation.city}, " unless organisation.city.blank?
      address += "#{organisation.state}, " unless organisation.state.blank?
      address += "#{organisation.post_code}, " unless organisation.post_code.blank?
      address += "#{organisation.country}, " unless organisation.country.blank?
      #
      unless address.blank?
        loc = MultiGeocoder.geocode(address)
        if loc.success
          organisation.lat = loc.lat
          organisation.lng = loc.lng
          organisation.save
          counter += 1
        end
      end
    end
    if counter > 0
      flash[:notice] = "Successfully updated #{counter} locations"
    else
      flash[:notice] = "no updates"
    end
    redirect_to :action => 'cron'
  end

  def populate_last_signup_step_at
    users = User.find(:all, :conditions => {:last_signup_step_at => nil})
    users.each {|user| user.update_attribute(:last_signup_step_at, user.created_at)}
    flash[:notice] = "done"
    redirect_to :action => 'cron'
  end
end
