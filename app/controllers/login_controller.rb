class LoginController < ApplicationController

  skip_before_filter  :ensure_organisation_is_set,
#                      :check_belonging_to_admission_group_and_update_admin_status,
                      :ensure_user_is_approved,
                      :ensure_user_have_signup_with_all_step

  skip_before_filter  :ensure_application_is_installed_by_facebook_user,
                      :setup_db_user,
                      :except => [:select_org, :update_org]
  def welcome
  end

  def profile_tab
  end
  
  def privacy
  end

  def tos
  end

  def select_org
    # we check that user does not come back here to change his organisation
    if @current_user.organisation.nil?
         organisations = Organisation.find(:all, :order => 'short_name ASC')
         @organisations_type = organisations.map {|x| [x.short_name, x.id]}
         #@organisations_type = @organisations_type.sort_by {|array_item| array_item[0]}
    else
      redirect_to home_url
    end
  end

  def update_org
    @current_user.organisation_id = params[:organisation]['organisation_id'].to_i
    @current_user.save_with_validation(false)
    set_default_profile_for_current_user # so @user.signup_step => 1
    redirect_to(:controller => 'users', :action => 'edit_profile', :id => @current_user.id)
  end
  
  def redirect_to_facebook_welcome
    # this one is necessary in case there is a call to http://changingroom.archenet.it
    redirect_to APPLICATION_CANVAS_URL
  end

end
