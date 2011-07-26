class MatchmakerController < ApplicationController
  layout 'main'

  
  def index
  end

  def exchanges
    # search
    # organisation_posts = search_organisation_posts_with(@current_user, {:filter => @selected_filter,
                                            #:country => @selected_country,
                                            #:organisation => @selected_organisation,
                                            #:area => @selected_area,
                                            #:category => @selected_category,
                                            #:duration => @selected_duration,
                                            #:location => @location,
                                            #:distance => @selected_close_to_km})
    #
    # Offers for user's area
    @offers_with_same_job_area            = search_organisation_posts_with(@current_user, {
                                            #:filter => @selected_filter,
                                            #:country => @selected_country,
                                            #:organisation => @selected_organisation,
                                            :area => @current_user.job_area#,
                                            #:category => @selected_category,
                                            #:duration => @selected_duration,
                                            #:location => @location,
                                            #:distance => @selected_close_to_km
                                            })
    case @offers_with_same_job_area.size
    when 0
      @offers_with_same_job_area_url = nil
    when 1
      @offers_with_same_job_area_url = @offers_with_same_job_area[0]
    else
      @offers_with_same_job_area_url = wanted_url(:template => 'only_results',
                                                  :clear_session => 'true',
                                                  :filter_area => @current_user.job_area)
    end
    #
    # Offers for user's area & category & for WORKER
    @offers_with_same_job_and_duration_for_worker =  search_organisation_posts_with(@current_user, {
                                                      #:filter => @selected_filter,
                                                      #:country => @selected_country,
                                                      #:organisation => @selected_organisation,
                                                      :area => @current_user.job_area,
                                                      :category => 'worker',
                                                      :duration => @current_user.go_as_worker
                                                      })
    case @offers_with_same_job_and_duration_for_worker.size
    when 0
      @offers_with_same_job_and_duration_for_worker_url = nil
    when 1
      @offers_with_same_job_and_duration_for_worker_url = @offers_with_same_job_and_duration_for_worker[0]
    else
      @offers_with_same_job_and_duration_for_worker_url = wanted_url(:template => 'only_results',
                                                                     :clear_session => 'true',
                                                                     :filter_area => @current_user.job_area,
                                                                     :filter_category => 'worker',
                                                                     :filter_duration => @current_user.go_as_worker)
    end
    # Offers for user's area & category & for volunteer
    @offers_with_same_job_and_duration_for_volunteer =  search_organisation_posts_with(@current_user, {
                                                      #:filter => @selected_filter,
                                                      #:country => @selected_country,
                                                      #:organisation => @selected_organisation,
                                                      :area => @current_user.job_area,
                                                      :category => 'volunteer',
                                                      :duration => @current_user.go_as_volunteer
                                                      })
    case @offers_with_same_job_and_duration_for_volunteer.size
    when 0
      @offers_with_same_job_and_duration_for_volunteer_url = nil
    when 1
      @offers_with_same_job_and_duration_for_volunteer_url = @offers_with_same_job_and_duration_for_volunteer[0]
    else
      @offers_with_same_job_and_duration_for_volunteer_url = wanted_url(:template => 'only_results',
                                                                        :clear_session => 'true',
                                                                        :filter_area => @current_user.job_area,
                                                                        :filter_category => 'volunteer',
                                                                        :filter_duration => @current_user.go_as_volunteer)
    end
    # Offers for user's area & category & for intern
    @offers_with_same_job_and_duration_for_intern =  search_organisation_posts_with(@current_user, {
                                                      #:filter => @selected_filter,
                                                      #:country => @selected_country,
                                                      #:organisation => @selected_organisation,
                                                      :area => @current_user.job_area,
                                                      :category => 'intern',
                                                      :duration => @current_user.go_as_intern
                                                      })
    case @offers_with_same_job_and_duration_for_intern.size
    when 0
      @offers_with_same_job_and_duration_for_intern_url = nil
    when 1
      @offers_with_same_job_and_duration_for_intern_url = @offers_with_same_job_and_duration_for_intern[0]
    else
      @offers_with_same_job_and_duration_for_intern_url = wanted_url(:template => 'only_results',
                                                                     :clear_session => 'true',
                                                                     :filter_area => @current_user.job_area,
                                                                     :filter_category => 'intern',
                                                                     :filter_duration => @current_user.go_as_intern)
    end
  end

  def colleagues
    # search
    #    users = search_users_with(@current_user, {:filter => @selected_filter,
    #                                            :country => @selected_country,
    #                                            :organisation => @selected_organisation,
    #                                            :gender => @selected_gender,
    #                                            :go_as => @selected_go_as,
    #                                            :location => @location,
    #                                            :distance => @selected_close_to_km})
    @colleague_distance = 150 # in km


    # same_job_area_and_role
#    @users_with_same_job_area_and_role   = search_users_with(@current_user, {:filter => 'same_job_area_and_role'})
#    @users_with_same_job_area_and_role.delete_if { |user| user.organisation == @current_user.organisation }
    @users_with_same_job_area_and_role = []

    case @users_with_same_job_area_and_role.size
    when 0
      @users_with_same_job_area_and_role_url = nil
    when 1
      @users_with_same_job_area_and_role_url = @users_with_same_job_area_and_role[0]
    else
      @users_with_same_job_area_and_role_url = search_url(:template => 'only_results',
                                                          :clear_session => 'true',
                                                          :filter => 'same_job_area_and_role')
    end

    if @users_with_same_job_area_and_role.empty?
      @users_with_same_job_area_and_role_and_hosting = '' # così non ho errore con .nil?
      @users_with_same_job_area_and_role_in_short_distance  = ''
      @users_with_same_job_area_and_role_and_visiting = ''
    else
      @users_with_same_job_area_and_role_and_hosting = Array.new(@users_with_same_job_area_and_role)
      @users_with_same_job_area_and_role_and_hosting.delete_if { |user| user.hosting == 'no' }
      @users_with_same_job_area_and_role_in_short_distance = Array.new(@users_with_same_job_area_and_role)
      @users_with_same_job_area_and_role_in_short_distance.delete_if { |user| user.distance_from(@current_user.get_geocoder_location) > @colleague_distance }
      @users_with_same_job_area_and_role_and_visiting = Array.new(@users_with_same_job_area_and_role)
      @users_with_same_job_area_and_role_and_visiting.delete_if { |user| user.go_as_visitor != 1 }
    end

    case @users_with_same_job_area_and_role_and_hosting.size
    when 0
      @users_with_same_job_area_and_role_and_hosting_url = nil
    when 1
      @users_with_same_job_area_and_role_and_hosting_url = @users_with_same_job_area_and_role_and_hosting[0]
    else
      @users_with_same_job_area_and_role_and_hosting_url = search_url(:template => 'only_results',
                                                                      :clear_session => 'true',
                                                                      :filter => 'hosting',
                                                                      :filter_job_area => @current_user.job_area,
                                                                      :filter_job_role => @current_user.job_role)
    end

    case @users_with_same_job_area_and_role_in_short_distance.size
    when 0
      @users_with_same_job_area_and_role_in_short_distance_url = nil
    when 1
      @users_with_same_job_area_and_role_in_short_distance_url = @users_with_same_job_area_and_role_in_short_distance[0]
    else
      @users_with_same_job_area_and_role_in_short_distance_url = search_url(:template => 'only_results',
                                                                            :clear_session => 'true',
                                                                            :filter_job_area => @current_user.job_area,
                                                                            :filter_job_role => @current_user.job_role,
                                                                            :filter_close_to_loc => @current_user.address,
                                                                            :filter_close_to_km => @colleague_distance)
    end

    case @users_with_same_job_area_and_role_and_visiting.size
    when 0
      @users_with_same_job_area_and_role_and_visiting_url = nil
    when 1
      @users_with_same_job_area_and_role_and_visiting_url = @users_with_same_job_area_and_role_and_visiting[0]
    else
      @users_with_same_job_area_and_role_and_visiting_url = search_url(:template => 'only_results',
                                                                      :clear_session => 'true',
                                                                      :filter_go_as => 'visitor',
                                                                      :filter_job_area => @current_user.job_area,
                                                                      :filter_job_role => @current_user.job_role)
    end

   # same_job_area
    @users_with_same_job_area   = search_users_with(@current_user, {:filter => 'same_job_area'})
    @users_with_same_job_area.delete_if { |user| user.organisation == @current_user.organisation }

    case @users_with_same_job_area.size
    when 0
      @users_with_same_job_area_url = nil
    when 1
      @users_with_same_job_area_url = @users_with_same_job_area[0]
    else
      @users_with_same_job_area_url = search_url(:template => 'only_results',
                                                          :clear_session => 'true',
                                                          :filter => 'same_job_area')
    end

    if @users_with_same_job_area.empty?
      @users_with_same_job_area_and_hosting = '' # così non ho errore con .nil?
      @users_with_same_job_area_in_short_distance  = ''
      @users_with_same_job_area_and_visiting = ''
    else
      @users_with_same_job_area_and_hosting = Array.new(@users_with_same_job_area)
      @users_with_same_job_area_and_hosting.delete_if { |user| user.hosting == 'no' }
      @users_with_same_job_area_in_short_distance = Array.new(@users_with_same_job_area)
      @users_with_same_job_area_in_short_distance.delete_if { |user| user.distance_from(@current_user.get_geocoder_location) > @colleague_distance }
      @users_with_same_job_area_and_visiting = Array.new(@users_with_same_job_area)
      @users_with_same_job_area_and_visiting.delete_if { |user| user.go_as_visitor != 1 }
    end

    case @users_with_same_job_area_and_hosting.size
    when 0
      @users_with_same_job_area_and_hosting_url = nil
    when 1
      @users_with_same_job_area_and_hosting_url = @users_with_same_job_area_and_hosting[0]
    else
      @users_with_same_job_area_and_hosting_url = search_url(:template => 'only_results',
                                                                      :clear_session => 'true',
                                                                      :filter => 'hosting',
                                                                      :filter_job_area => @current_user.job_area)
    end

    case @users_with_same_job_area_in_short_distance.size
    when 0
      @users_with_same_job_area_in_short_distance_url = nil
    when 1
      @users_with_same_job_area_in_short_distance_url = @users_with_same_job_area_in_short_distance[0]
    else
      @users_with_same_job_area_in_short_distance_url = search_url(:template => 'only_results',
                                                                            :clear_session => 'true',
                                                                            :filter_job_area => @current_user.job_area,
                                                                            :filter_close_to_loc => @current_user.address,
                                                                            :filter_close_to_km => @colleague_distance)
    end

    case @users_with_same_job_area_and_visiting.size
    when 0
      @users_with_same_job_area_and_visiting_url = nil
    when 1
      @users_with_same_job_area_and_visiting_url = @users_with_same_job_area_and_visiting[0]
    else
      @users_with_same_job_area_and_visiting_url = search_url(:template => 'only_results',
                                                                      :clear_session => 'true',
                                                                      :filter_go_as => 'visitor',
                                                                      :filter_job_area => @current_user.job_area)
    end
  end

  def connection_with_location
    session[:selected_close_to_loc] = params[:filter_close_to_loc]  || session[:selected_close_to_loc]
    @selected_close_to_loc  = session[:selected_close_to_loc]

    unless @selected_close_to_loc.blank?
      @selected_close_to_loc.strip! #remove spaces
      #@location = MultiGeocoder.geocode(@selected_close_to_loc+', Europe')
      correction_pre = 'city of '
      correction_post = ' ,Europe'
      @location = GoogleGeocoder.geocode(correction_pre+@selected_close_to_loc+correction_post)
      if @location.success && (@location.full_address != "Europe, ZZ")
        @selected_close_to_loc = @location.full_address
      else
        @location = nil
        flash.now[:error] = 'Unable to spot location', "System could not recognize the location: '#{@selected_close_to_loc}', check for spelling"
        @no_results = true
        return
      end
    end
        # search
    unless @location.nil?
      users_close_to_loc      = search_users_with(@current_user, {
                                                     :location => @location})

      @users_close_to_loc = users_close_to_loc.sort_by {|user| user.distance_from(@location)}
      if @users_close_to_loc.size > 3
        @users_close_to_loc_to_show = 3
      else
        @users_close_to_loc_to_show = @users_close_to_loc.size
      end
      @users_close_to_loc_last_distance = @users_close_to_loc[@users_close_to_loc_to_show-1].distance_from(@location).round
      @users_close_to_loc_distance =  CLOSE_TO_KM_DAILY_TRIP
      @users_close_to_log_url  = search_url( :template => 'only_results',
                                        :clear_session => 'true',
                                        :filter_close_to_loc => @selected_close_to_loc )

      organisations_close_to_loc      = search_organisations_with(@current_user, {
                                                     :location => @location})

      @organisations_close_to_loc = organisations_close_to_loc.sort_by {|organisation| organisation.distance_from(@location)}
      #@organisation_close_to_loc = @organisations_close_to_loc[0]

    end

    # Connection with organisation
    @filter_organisation_options_for_select = Organisation.find(:all, :order => 'short_name ASC').map { |organisation| [organisation.short_name+" (#{organisation.country})", organisation.id.to_s]}
    @selected_organisation_friends = []# = @current_user.facebook_session.user.friends.delete_if {|facebooker_user| ||}
  end

  def for_your_organisation
    # proporre matches per la sua organizzazione
    @users_volunteers = search_users_with(@current_user, {:go_as => 'volunteer'})
    @users_volunteers_url                            =  search_url( :template => 'only_results',
                                                                    :clear_session => 'true',
                                                                    :filter_go_as => 'volunteer')    
  end

end