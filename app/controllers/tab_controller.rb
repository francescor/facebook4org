class TabController < ApplicationController

  # copiare da login_controller
  skip_before_filter  :ensure_organisation_is_set,
#                      :check_belonging_to_admission_group_and_update_admin_status,
                                        :ensure_user_is_approved,
                      :ensure_user_have_signup_with_all_step

  skip_before_filter  :ensure_application_is_installed_by_facebook_user,
                      :setup_db_user

  def index
    @number_of_users = User.find(:all, :conditions => BASE_USER_FIND_CONDITIONS).size
    @latest_users = User.find(:all, :order => 'last_signup_step_at DESC', :limit => 3, :conditions => BASE_USER_FIND_CONDITIONS)
    @online_users = User.find(:all, :order => 'last_access DESC',  :conditions => BASE_USER_FIND_CONDITIONS+" AND last_access > '#{my_one_hour_ago_utc.to_date} #{my_one_hour_ago_utc.hour}:#{my_one_hour_ago_utc.min}:00'")
    @latest_organisation_posts = OrganisationPost.find(:all, :order => 'created_at DESC', :limit => 5, :conditions => BASE_ORGANISATION_POST_FIND_CONDITIONS)
        # CJI Jobs
    @cji_jobs = my_fetch_url 'http://www.culturejobsinternational.org/widget/cji_widget.cfm'
    @cji_jobs.gsub!(/style\=\\"color:#00b9e4;\\"/, '')
    @cji_jobs.gsub!(/document.write\('/, '')
    @cji_jobs.gsub!(/ '\)/, '')
    @cji_jobs.gsub!(/\\r\\n/, '')
    @cji_jobs.gsub!(/\\t/, '')
    @cji_jobs.gsub!(/<\/div>/, '')
#    @cji_jobs.gsub!(/<ul>/, '')
#    @cji_jobs.gsub!(/<\/ul>/, '')
#    @cji_jobs.gsub!(/<li>/, '')
#    @cji_jobs.gsub!(/<\/li>/, '')
  end

end
