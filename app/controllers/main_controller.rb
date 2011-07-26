class MainController < ApplicationController

  skip_before_filter  :ensure_have_entered_email_address,
                      :except => [:index, :settings, :search, :wanted, :search_organisations]
  skip_before_filter  :ensure_user_is_approved,
                      # elenco azioni in cui FARE il controllo
                      :except => [:index, :my_notifications, :search, :wanted, :search_organisations, :message_board, :feedback]

  def test

  end

  def add_tab_example
    
  end

  def index_for_pending_users
  end

  def message_board
  end

  def feedback
  end

  def index
    if params[:ref] == 'bookmarks'
#      counter = @current_user.facebooker_session.user.dashboard_count
#      redirect_to "notifications?ref=bookmarks&dashboard_count=#{counter}"
      redirect_to 'my_notifications?ref=bookmarks'
      return
    end
    # Visits
    @visits = Visit.find(:all, :order => 'updated_at')
    # Contacts
    @contacts = Contact.find(:all, :order => 'updated_at')
    


    @number_of_users = User.find(:all, :conditions => BASE_USER_FIND_CONDITIONS).size
    @latest_users = User.find(:all, :order => 'last_signup_step_at DESC', :limit => 3, :conditions => BASE_USER_FIND_CONDITIONS+" AND is_approved = true")
    @online_users = User.find(:all, :order => 'last_access DESC',  :conditions => BASE_USER_FIND_CONDITIONS+" AND last_access > '#{my_one_hour_ago_utc.to_date} #{my_one_hour_ago_utc.hour}:#{my_one_hour_ago_utc.min}:00'")
    #@latest_organisations = Organisation.find(:all, :order => 'created_at DESC', :limit => 5, :conditions => BASE_ORGANISATION_FIND_CONDITIONS)
    @latest_organisation_posts = OrganisationPost.find(:all, :order => 'updated_at DESC', :limit => 5, :conditions => BASE_ORGANISATION_POST_FIND_CONDITIONS)
    #

    
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
      @offers_with_same_job_area_url = wanted_url(:template => 'advanced',
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
      @offers_with_same_job_and_duration_for_worker_url = wanted_url(:template => 'advanced',
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
      @offers_with_same_job_and_duration_for_volunteer_url = wanted_url(:template => 'advanced',
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
      @offers_with_same_job_and_duration_for_intern_url = wanted_url(:template => 'advanced',
                                                                     :clear_session => 'true',
                                                                     :filter_area => @current_user.job_area,
                                                                     :filter_category => 'intern',
                                                                     :filter_duration => @current_user.go_as_intern)
    end

    # proporre matches per la sua organizzazione
    @users_volunteers = search_users_with(@current_user, {:go_as => 'volunteer'})
    @users_volunteers_url                            =  search_url( :template => 'advanced',
                                                                      :clear_session => 'true',
                                                                      :filter_go_as => 'volunteer')

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
  end # index

  def my_notifications
    @user = User.find(params[:id] || @current_user.id)
    unless @current_user == @user || @current_user.is_admin
      redirect_to :controller => :main
    end
    @notifications = @user.notifications_including_general
  end

  def settings
    #
    @url_for_iframe = FACEBOOKER['callback_url'] + "/iframe/iframe_user_map?"+
                                 "user_id=#{@current_user.id}&"+
                                 "searching_user_id=#{@current_user.id}"
  end

  ####################  SEARCH USERS

  def search

    # Quick Search
    if params[:show_quick_search] == 'yes'
      # we exclude current user from the quick search
      @users_for_quick_search = User.find(:all,
                      :conditions => BASE_USER_FIND_CONDITIONS+ " AND id <> #{@current_user.id}" )
      @organisations_for_quick_search = Organisation.all(:order => 'short_name ASC')
      if @quick_search_text_val.nil?
        @quick_search_text = params[:quick_search_text]
        unless @quick_search_text.blank?
          @quick_search_text.downcase.strip!
          organisations = search_organisations_with(@current_user, {:name => @quick_search_text })
          if organisations.size == 1
            redirect_to organisations[0]
          else
            users = search_users_with(@current_user, {:name => @quick_search_text })
            if users.size == 1
              redirect_to users[0]
            elsif organisations.size > 1
              redirect_to search_organisations_url(:template => 'advanced',
                :clear_session => 'true',
                :filter_name => @quick_search_text )
            elsif users.size > 1
              redirect_to search_url(:template => 'advanced',
                                     :clear_session => 'true',
                                     :filter_name => @quick_search_text )
            else
              # no users, no organisations...
              # TODO add deeper search? over the wanted?
              flash[:notice] = "No Users/Organisations have '#{@quick_search_text}' in their name"
              # NO redirect_to search_url(:reset => 'all', :template => 'basic', :output => 'list', :show_quick_search => 'yes', :show_org_search=> 'yes')
            end
          end
        end
      elsif @quick_search_text_val.split(':')[0] == 'user'
        # we have a user
        redirect_to :controller => :users, :id => @quick_search_text_val.split(':')[1]
      elsif @quick_search_text_val.split(':')[0] == 'organisation'
        # we have an organisation
        redirect_to :controller => :organisations, :id => @quick_search_text_val.split(':')[1]
      end
    end

   
    #
    default_template      = 'basic'
    default_output        = 'list'
    default_filter        = 'all'
    default_organisation  = ''
    default_country       = ''
    default_gender        = ''
    default_order         = 'country'
    default_go_as         = ''
    default_per_page      = '50' # tienilo a stringa che e' + facile
    default_close_to_km   = '' # keep it like this!
    default_close_to_loc  = ''
    default_job_area      = ''
    #default_job_role      = ''
    default_friendship    = ''
    default_name          = ''


    @filter_options_for_select =    [[ 'All People'                     , 'all'],
                                     [ 'Just from my Organisation'      , 'my_organisation'],
                                     #[ 'Recently added'                 , 'recently_added']
                                     [ "People working in my job area"  , 'same_job_area'],
                                   #  [ "People having my job role"      , 'same_job_role'],
                                   #  [ "People with my job role & area" , 'same_job_area_and_role'],
                                     [ 'Volunteers for my organisation' , 'volunteers'],
                                     [ 'Interns for my organisation'    , 'interns'],
                                     [ 'Workers for my organisation'    , 'workers'],
                                     [ 'People offering hospitality'    , 'hosting'],
                                     [ 'People who want to visit'       , 'visitors']]
    #
    @filter_organisation_options_for_select = Organisation.find(:all, :order => 'short_name ASC').map { |organisation| [organisation.short_name+" (#{organisation.country})", organisation.id.to_s]}
    #@filter_organisation_options_for_select = @filter_organisation_options_for_select.sort_by {|array_item| array_item[0]}
    @filter_organisation_options_for_select.insert(0,['',''])
    @filter_country_options_for_select = COUNTRY_TYPES
    @filter_country_options_for_select[0] = ['', '']
    @filter_gender_options_for_select = GENDER_TYPES
    @filter_gender_options_for_select[0]  = ['', '']
    @filter_go_as_options_for_select = EXCHANGE_TYPES
    @filter_go_as_options_for_select[0]   = ['', '']
    @filter_close_to_km_options_for_select = CLOSE_TO_KM_TYPES
    @filter_close_to_km_options_for_select[0]   = ['', '']
    @filter_job_area_options_for_select = JOB_AREA_TYPES
    @filter_job_area_options_for_select[0] = ['', '']
#    @filter_job_role_options_for_select = JOB_ROLE_TYPES
#    @filter_job_role_options_for_select[0] = ['', '']
    @filter_friendship_options_for_select = FRIENDSHIP_TYPES
    @filter_friendship_options_for_select[0] = ['', '']

    @order_options_for_select = [[  'Country'             ,  'country'],
                                 [  'Organisation'        ,  'organisation'],
                                 [  'Job Area'            ,  'job_area'],
                                 #[  'Job Role'            ,  'job_role'],
                                 [  'Hosting preferences' ,  'hosting'],
                                 [  'Recently added'      ,  'created_at'],
                                 [  'Board Members first' ,  'is_board_member'],
                                 [  'Directors/Presidents first' ,  'is_boss'],
                                 [  'Directors/Presidents first' ,  'is_boss'],
                                 [  'Volunteers first' ,  'hours_as_volunteer'],
                                 [  'Workers first' ,  'hours_as_worker'],
                                 [  'Managers first' ,  'is_manager'],
                                 ]


    @per_page_for_select =       [['5 people', '5'],
                                  ['10 people', '10'],
                                  ['50 people' , '50'],
                                  ['100 people' , '100']]
                                
    if params[:reset] == 'all'
      # user have just entered the SEARCH menu, so we reset everything
      session[:template]              = nil
      session[:output]                = nil
      session[:selected_filter]       = nil
      session[:selected_organisation] = nil
      session[:selected_country]      = nil
      session[:selected_gender]       = nil
      session[:selected_go_as]        = nil
      session[:selected_order]        = nil
      session[:selected_per_page]     = nil
      session[:selected_close_to_km]  = nil
      session[:selected_close_to_loc] = nil
      session[:selected_job_area]     = nil
#      session[:selected_job_role]     = nil
      session[:selected_friendship]   = nil
      session[:selected_name]         = nil
      @selected_template = params[:template]
      @selected_output   = params[:output]   
      @selected_filter   = default_filter
      @selected_per_page = default_per_page
      @search_action = search_url(:template => @selected_template, :output=> @selected_output)
      return
    end

#    if params[:reset]=='to_basic_search'
#      # user have just entered the SEARCH form OR cliked on BASIC SEARCH (so we reset the advanced)
#      session[:selected_organisation] = nil
#      session[:selected_country]      = nil
#      session[:selected_gender]       = nil
#      session[:selected_go_as]        = nil
#      session[:selected_per_page]     = nil
#      session[:selected_close_to_km]  = nil
#      session[:selected_close_to_loc] = nil
#      session[:selected_job_area]     = nil
#      session[:selected_job_role]     = nil
#    end

    if params[:clear_session] == 'true'
      # if coming to the search page from someplaces else
      session[:template]              = nil
      session[:output]                = nil
      session[:selected_filter]       = nil
      session[:selected_organisation] = nil
      session[:selected_country]      = nil
      session[:selected_gender]       = nil
      session[:selected_go_as]        = nil
      session[:selected_order]        = nil
      session[:selected_per_page]     = nil
      session[:selected_close_to_km]  = nil
      session[:selected_close_to_loc] = nil
      session[:selected_job_area]     = nil
#      session[:selected_job_role]     = nil
      session[:selected_friendship]   = nil
      session[:selected_name]         = nil

    end
    #
    # Per tutti vale
    # session[:ciccio] = params(l'ha scelta) || session(la eredita) || (la prende di default)
    # @selected_ciccio = session[:ciccio]

    session[:template]              = params[:template]             || session[:template]               || default_template
    session[:output]                = params[:output]               || session[:output]                 || default_output
    session[:selected_filter]       = params[:filter]               || session[:selected_filter]        || default_filter
    session[:selected_organisation] = params[:filter_organisation]  || session[:selected_organisation]  || default_organisation
    session[:selected_country]      = params[:filter_country]       || session[:selected_country]       || default_country
    session[:selected_gender]       = params[:filter_gender]        || session[:selected_gender]        || default_gender
    session[:selected_go_as]        = params[:filter_go_as]         || session[:selected_go_as]         || default_go_as
    session[:selected_order]        = params[:order]                || session[:selected_order]         || default_order
    session[:selected_per_page]     = params[:per_page]             || session[:selected_per_page]      || default_per_page
    session[:selected_close_to_km]  = params[:filter_close_to_km]   || session[:selected_close_to_km]   || default_close_to_km
    session[:selected_close_to_loc] = params[:filter_close_to_loc]  || session[:selected_close_to_loc]  || default_close_to_loc
    session[:selected_job_area]     = params[:filter_job_area]      || session[:selected_job_area]      || default_job_area
#    session[:selected_job_role]     = params[:filter_job_role]      || session[:selected_job_role]      || default_job_role
    session[:selected_friendship]   = params[:filter_friendship]    || session[:selected_friendship]    || default_friendship
    session[:selected_name]         = params[:filter_name]          || session[:selected_name]          || default_name

    #
    @selected_template      = session[:template]
    @selected_output        = session[:output]
    @selected_filter        = session[:selected_filter]
    @selected_organisation  = session[:selected_organisation]
    @selected_country       = session[:selected_country]
    @selected_gender        = session[:selected_gender]
    @selected_go_as         = session[:selected_go_as]
    @selected_order         = session[:selected_order]
    @selected_per_page      = session[:selected_per_page]
    @selected_close_to_km   = session[:selected_close_to_km]
    @selected_close_to_loc  = session[:selected_close_to_loc]
    @selected_job_area      = session[:selected_job_area]
   # @selected_job_role      = session[:selected_job_role]
    @selected_friendship    = session[:selected_friendship]
    @selected_name          = session[:selected_name]
    #
    unless @selected_template == 'only_results'
      # forzo template a basic/advanced, nel caso non ci siano o no valori
      #
      advanced_input =   @selected_organisation +
                            @selected_country +
                            @selected_gender +
                            @selected_go_as +
                            @selected_close_to_km +
                            @selected_close_to_loc +
                            @selected_job_area +
                          #  @selected_job_role +
                            @selected_friendship +
                            @selected_name

      if advanced_input.blank?
        @selected_template = 'basic'
      else
        @selected_template = 'advanced'
      end
    end
    #@search_action = "search?template=#{@selected_template}&output=#{@selected_output}"
    # ovvero:
    @search_action = search_url(:output=> @selected_output, :template => @selected_template)
    #
    unless @selected_close_to_loc.blank?
      @selected_close_to_loc.strip! #remove spaces
      #@location = MultiGeocoder.geocode(@selected_close_to_loc+', Europe')
      correction = @selected_country.capitalize+', Europe' || 'Europe'
      @location = GoogleGeocoder.geocode(@selected_close_to_loc+', '+correction)
      if @location.success && (@location.full_address != "Europe, ZZ") 
        @selected_close_to_loc = @location.full_address
        @order_options_for_select.insert(0, ["Distance from location", 'distance'])
        if params[:order].nil? && session[:selected_order]==default_order
          @selected_order = 'distance'
        end
      else
        @location = nil
        flash.now[:error] = 'Unable to spot location', "System could not recognize the location: '#{@selected_close_to_loc}', check for spelling"
        @no_results = true
        return
      end
    end

    # MAP
    #if params[:output]=='map'
       @url_for_iframe = FACEBOOKER['callback_url'] +  "/iframe/iframe_users_map?"+
                                 "filter=#{@selected_filter}&" +
                                 "country=#{u(@selected_country)}&" +  # u() needed for spaces
                                 "organisation=#{u(@selected_organisation)}&" +
                                 "gender=#{@selected_gender}&" +
                                 "go_as=#{@selected_go_as}&" +
                                 "location_lat=#{@location.nil? ? 0 : u(@location.lat)}&" +
                                 "location_lng=#{@location.nil? ? 0 : u(@location.lng)}&" +
                                 "distance=#{@selected_close_to_km}&" +
                                 "location_full_address=#{u(@location.full_address) unless @location.nil?}&"+
                                 "searching_user_id=#{@current_user.id}&"+
                                 "job_area=#{@selected_job_area}&" +
            #                     "job_role=#{@selected_job_role}&" +
                                 "friendship=#{@selected_friendship}&" +
                                 "name=#{@selected_name}"
      #return
    #end

    # search
    users = search_users_with(@current_user, {:filter => @selected_filter,
                                            :country => @selected_country,
                                            :organisation => @selected_organisation,
                                            :gender => @selected_gender,
                                            :go_as => @selected_go_as,
                                            :location => @location,
                                            :distance => @selected_close_to_km,
                                            :job_area => @selected_job_area,
#                                            :job_role => @selected_job_role,
                                            :friendship => @selected_friendship,
                                            :name => @selected_name})
    if users.size == 0
      @no_results = true
      return
    end
    # ORDER
    #
    if %w{country hosting created_at}.include? @selected_order
      # valido solo per le *colonne* di User
      @ordered_users = users.sort_by {|user| user.send(@selected_order)}
      @ordered_users.reverse! if %w{created_at}.include? @selected_order
    elsif %w{is_board_member is_boss is_manager}.include? @selected_order
      # valido solo per le *colonne* true/false
      @ordered_users = users.sort_by {|user| user.send(@selected_order).to_s}
      @ordered_users.reverse!
    elsif %w{hours_as_worker hours_as_volunteer}.include? @selected_order
      # valido solo per le *colonne* hours... ke possono avere nil
      @ordered_users = users.sort_by {|user| user.send(@selected_order).to_i}
      @ordered_users.reverse!
    elsif @selected_order == 'organisation'
      @ordered_users = users.sort_by {|user| user.organisation} # Ok, dato ke ho definito <=> nel modello organizzazioni
    elsif @selected_order == 'job_area'
      ordered = JOB_AREA_TYPES.map{|x| x[0] }.sort
      # vedi Black p.405
      # nb: non serve levare "--Select" :)
      @ordered_users = users.sort_by {|user| ordered.index(user.job_area_in_words) || 0}
#    elsif @selected_order == 'job_role'
#      ordered = JOB_ROLE_TYPES.map{|x| x[0] }.sort
#      # vedi Black p.405
#      # nb: non serve levare "--Select" :)
#      @ordered_users = users.sort_by {|user| ordered.index(user.job_role_in_words) || 0}
    elsif @selected_order == 'distance'
      unless @location && @location.success # controllo di sicurezza
        flash[:error] = 'Internal Order Error', 'Trying to order on distance on a missing location'
        @no_results = true
        return
      end
      @ordered_users = users.sort_by {|user| user.distance_from(@location)}
    else
      flash[:error] = 'Order Error', 'Order not yet implemented'
      @no_results = true
      return
    end

    # PAGINATE
    #
    # per customizzazione will_paginate vedi:
    #http://www.pathf.com/blogs/2008/06/how-to-use-will_paginate-with-non-activerecord-collectionarray/@page_results = @posts.paginate(params[:current_page], params[:per_page])
    @page_results = @ordered_users.paginate(:page => params[:page], :per_page => @selected_per_page.to_i)
    # Results 4-6 of a total of 22
    # Results @item_start @item_end of a total of @item_total
    @item_start = @page_results.offset+1
    @item_total = @page_results.total_entries
    @item_end =  @page_results.offset+@page_results.per_page
    @item_end = @item_total if @item_end > @item_total
  end # search


  ####################  wanted

  def wanted
    #
    #
    default_template      = 'basic'
    default_output        = 'list'
    default_filter        = 'all'
    default_organisation  = ''
    default_country       = ''
    default_order         = 'created_at'
    default_area          = ''
    default_category      = ''
    default_duration      = ''
    default_per_page      = '10' # tienilo a stringa che e' + facile
    default_close_to_km   = '' # keep it like this!
    default_close_to_loc  = ''


    @filter_options_for_select =    [[ 'All offers'                     , 'all'],
                                     #[ 'Recently added'                 , 'recently_added']
                                     [ 'Offers for my job area'         , 'same_job_area'],
                                     [ 'Offers from my organisation'    , 'my_organisation']]

    #
    @filter_organisation_options_for_select = Organisation.find(:all, :order => 'short_name ASC').map { |organisation| [organisation.short_name+" (#{organisation.country})", organisation.id.to_s]}
    #@filter_organisation_options_for_select = @filter_organisation_options_for_select.sort_by {|array_item| array_item[0]}
    @filter_organisation_options_for_select.insert(0,['',''])
    @filter_country_options_for_select = COUNTRY_TYPES
    @filter_country_options_for_select[0] = ['', '']
    @filter_area_options_for_select = ORGANISATION_POST_AREA_TYPES
    @filter_area_options_for_select[0]   = ['', '']
    @filter_category_options_for_select = ORGANISATION_POST_CATEGORY_TYPES
    @filter_category_options_for_select[0]   = ['', '']
    @filter_duration_options_for_select = ORGANISATION_POST_DURATION_TYPES.each{|x| x[1] = x[1].to_s}
    @filter_duration_options_for_select[0]   = ['', '']

    @filter_close_to_km_options_for_select = CLOSE_TO_KM_TYPES
    @filter_close_to_km_options_for_select[0]   = ['', '']

    @order_options_for_select = [[  'Recently added '     ,  'created_at'],
                                 [  'Country'             ,  'country'],
                                 [  'Organisation'        ,  'organisation'],
                                 [  'Duration'            ,  'duration'],
                                 [  'Area'                ,  'area'],
                                 [  'Role'                ,  'category'],
                                 [  'Recently updated'    ,  'updated_at'],
                                 ]


    @per_page_for_select =       [['5 offers', '5'],
                                  ['10 offers', '10'],
                                  ['50 offers' , '50'],
                                  ['100 offers' , '100']]

    if params[:reset] == 'all'
      # user have just entered the WANTED menu, so we reset everything
      session[:template]              = nil
      session[:output]                = nil
      session[:selected_filter]       = nil
      session[:selected_organisation] = nil
      session[:selected_country]      = nil
      session[:selected_area]         = nil
      session[:selected_category]     = nil
      session[:selected_duration]     = nil
      session[:selected_order]        = nil
      session[:selected_per_page]     = nil
      session[:selected_close_to_km]  = nil
      session[:selected_close_to_loc] = nil
      @selected_template = params[:template]
      @selected_output   = params[:output]
      @selected_filter   = default_filter
      @selected_per_page = default_per_page
      @wanted_action = wanted_url(:template => @selected_template, :output=> @selected_output)
      #return
    end

    #    if params[:reset]=='to_basic_wanted'
    #      # user have just entered the SEARCH form OR cliked on BASIC SEARCH (so we reset the advanced)
    #      session[:selected_organisation] = nil
    #      session[:selected_country]      = nil
    #      session[:selected_area]         = nil
    #      session[:selected_category]     = nil
    #      session[:selected_duration]     = nil
    #      session[:selected_per_page]     = nil
    #      session[:selected_close_to_km]  = nil
    #      session[:selected_close_to_loc] = nil
    #    end

    if params[:clear_session] == 'true'
      # if coming to the wanted page from someplaces else
      session[:template]              = nil
      session[:output]                = nil
      session[:selected_filter]       = nil
      session[:selected_organisation] = nil
      session[:selected_country]      = nil
      session[:selected_area]         = nil
      session[:selected_category]     = nil
      session[:selected_duration]     = nil
      session[:selected_order]        = nil
      session[:selected_per_page]     = nil
      session[:selected_close_to_km]  = nil
      session[:selected_close_to_loc] = nil
    end
    #
    # Per tutti vale
    # session[:ciccio] = params(l'ha scelta) || session(la eredita) || (la prende di default)
    # @selected_ciccio = session[:ciccio]

    session[:template]              = params[:template]             || session[:template]               || default_template
    session[:output]                = params[:output]               || session[:output]                 || default_output
    session[:selected_filter]       = params[:filter]               || session[:selected_filter]        || default_filter
    session[:selected_organisation] = params[:filter_organisation]  || session[:selected_organisation]  || default_organisation
    session[:selected_country]      = params[:filter_country]       || session[:selected_country]       || default_country
    session[:selected_area]         = params[:filter_area]          || session[:selected_area]          || default_area
    session[:selected_category]     = params[:filter_category]      || session[:selected_category]      || default_category
    session[:selected_duration]     = params[:filter_duration]      || session[:selected_duration]      || default_duration
    session[:selected_order]        = params[:order]                || session[:selected_order]         || default_order
    session[:selected_per_page]     = params[:per_page]             || session[:selected_per_page]      || default_per_page
    session[:selected_close_to_km]  = params[:filter_close_to_km]   || session[:selected_close_to_km]   || default_close_to_km
    session[:selected_close_to_loc] = params[:filter_close_to_loc]  || session[:selected_close_to_loc]  || default_close_to_loc

    #
    @selected_template      = session[:template]
    @selected_output        = session[:output]
    @selected_filter        = session[:selected_filter]
    @selected_organisation  = session[:selected_organisation]
    @selected_country       = session[:selected_country]
    @selected_area          = session[:selected_area]
    @selected_category      = session[:selected_category]
    @selected_duration      = session[:selected_duration]
    @selected_order         = session[:selected_order]
    @selected_per_page      = session[:selected_per_page]
    @selected_close_to_km   = session[:selected_close_to_km]
    @selected_close_to_loc  = session[:selected_close_to_loc]

    unless @selected_template == 'only_results'
      # forzo template a basic/advanced, nel caso non ci siano o no valori
      #
      advanced_input =   @selected_organisation +
                            @selected_country +
                            @selected_area +
                            @selected_category +
                            @selected_duration +
                            @selected_close_to_km +
                            @selected_close_to_loc
      if advanced_input.blank?
        @selected_template = 'basic'
      else
        @selected_template = 'advanced'
      end
    end
    
    #@search_action = "search?template=#{@selected_template}&output=#{@selected_output}"
    # ovvero:
    @wanted_action = wanted_url(:template => @selected_template, :output=> @selected_output)
    #
    unless @selected_close_to_loc.blank?
      @selected_close_to_loc.strip! #remove spaces
      #@location = MultiGeocoder.geocode(@selected_close_to_loc+', Europe')
      correction = @selected_country.capitalize+', Europe' || 'Europe'
      @location = GoogleGeocoder.geocode(@selected_close_to_loc+', '+correction)
      if @location.success && (@location.full_address != "Europe, ZZ")
        @selected_close_to_loc = @location.full_address
        @order_options_for_select.insert(0, ["Distance from location", 'distance'])
        if params[:order].nil? && session[:selected_order]==default_order
          @selected_order = 'distance'
        end
      else
        @location = nil
        flash.now[:error] = 'Unable to spot location', "System could not recognize the location: '#{@selected_close_to_loc}', check for spelling"
        @no_results = true
        return
      end
    end

    # MAP
    #if params[:output]=='map'
       @url_for_iframe = FACEBOOKER['callback_url'] +  "/iframe/iframe_organisation_posts_map?"+
                                 "filter=#{@selected_filter}&" +
                                 "country=#{u(@selected_country)}&" +  # u() needed for spaces
                                 "organisation=#{u(@selected_organisation)}&" +
                                 "area=#{@selected_area}&" +
                                 "category=#{@selected_category}&" +
                                 "duration=#{@selected_duration}&" +
                                 "location_lat=#{@location.nil? ? 0 : u(@location.lat)}&" +
                                 "location_lng=#{@location.nil? ? 0 : u(@location.lng)}&" +
                                 "distance=#{@selected_close_to_km}&" +
                                 "location_full_address=#{u(@location.full_address) unless @location.nil?}&"+
                                 "searching_user_id=#{@current_user.id}"
      #return
    #end

    # search
    organisation_posts = search_organisation_posts_with(@current_user, {:filter => @selected_filter,
                                            :country => @selected_country,
                                            :organisation => @selected_organisation,
                                            :area => @selected_area,
                                            :category => @selected_category,
                                            :duration => @selected_duration,
                                            :location => @location,
                                            :distance => @selected_close_to_km})
    if organisation_posts.size == 0
      @no_results = true
      return
    end
    # ORDER
    #
    if %w{duration category created_at updated_at}.include? @selected_order
      # valido solo per le *colonne* di User
      @ordered_organisation_posts = organisation_posts.sort_by {|organisation_post| organisation_post.send(@selected_order)}
      @ordered_organisation_posts.reverse! if %w{created_at updated_at}.include? @selected_order
#    elsif @selected_order == 'updated_at'
#      @ordered_organisation_posts = organisation_posts.sort_by {|organisation_post| organisation_post.updated_at}
#      @ordered_organisation_posts.reverse!
    elsif @selected_order == 'organisation'
      @ordered_organisation_posts = organisation_posts.sort_by {|organisation_post| organisation_post.organisation} # Ok, dato ke ho definito <=> nel modello organizzazioni
    elsif @selected_order == 'country'
      @ordered_organisation_posts = organisation_posts.sort_by {|organisation_post| organisation_post.organisation.country}
    elsif @selected_order == 'area'
      ordered = ORGANISATION_POST_AREA_TYPES.map{|x| x[0] }.sort
      # vedi Black p.405
      # nb: non serve levare "--Select" :)
      @ordered_organisation_posts = organisation_posts.sort_by {|organisation_post| ordered.index(organisation_post.area_in_words) || 0}
#    elsif @selected_order == 'category'
#      @ordered_organisation_posts = organisation_posts.sort_by {|organisation_post| organisation_post.category}
    #      ordered = ORGANISATION_POST_CATEGORY_TYPES.map{|x| x[0] }.sort
    #      # vedi Black p.405
    #      # nb: non serve levare "--Select" :)
    #      @ordered_organisation_posts = organisation_posts.sort_by {|organisation_post| ordered.index(organisation_post.category_in_words) || 0}
    elsif @selected_order == 'distance'
      unless @location && @location.success # controllo di sicurezza
        flash[:error] = 'Internal Order Error', 'Trying to order on distance on a missing location'
        @no_results = true
        return
      end
      @ordered_organisation_posts = organisation_posts.sort_by {|organisation_post| organisation_post.organisation.distance_from(@location)}
    else
      flash[:error] = 'Order Error', 'Order not yet implemented'
      @no_results = true
      return
    end

    # PAGINATE
    #
    # per customizzazione will_paginate vedi:
    #http://www.pathf.com/blogs/2008/06/how-to-use-will_paginate-with-non-activerecord-collectionarray/@page_results = @posts.paginate(params[:current_page], params[:per_page])
    @page_results = @ordered_organisation_posts.paginate(:page => params[:page], :per_page => @selected_per_page.to_i)
    # Results 4-6 of a total of 22
    # Results @item_start @item_end of a total of @item_total
    @item_start = @page_results.offset+1
    @item_total = @page_results.total_entries
    @item_end =  @page_results.offset+@page_results.per_page
    @item_end = @item_total if @item_end > @item_total
  end # wanted



 ####################  SEARCH

  def search_organisations
    #
    default_template      = 'basic'
    default_output        = 'list'
    default_filter        = 'all'
    default_organisation  = ''
    default_country       = ''
    default_order         = 'country'
    default_per_page      = '100' # tienilo a stringa che e' + facile
    default_close_to_km   = '' # keep it like this!
    default_close_to_loc  = ''
    default_name          = ''

    @filter_options_for_select =    [[ 'All Organisations'              , 'all'],
                                     [ "#{MAIN_ORG_SHORT_NAME} Members only"               , 'members']
                                     ]
    #
    @filter_organisation_options_for_select = Organisation.find(:all, :order => 'short_name ASC').map { |organisation| [organisation.short_name+" (#{organisation.country})", organisation.id.to_s]}
    #@filter_organisation_options_for_select = @filter_organisation_options_for_select.sort_by {|array_item| array_item[0]}
    @filter_organisation_options_for_select.insert(0,['',''])
    @filter_country_options_for_select = COUNTRY_TYPES
    @filter_country_options_for_select[0] = ['', '']
    @filter_close_to_km_options_for_select = CLOSE_TO_KM_TYPES
    @filter_close_to_km_options_for_select[0]   = ['', '']


    @order_options_for_select = [[  'Country'           ,  'country'],
                                 [  "Name"              ,  'short_name'],
                                 [  'City'              ,  'city'],
                                 [  "Membership in #{MAIN_ORG_SHORT_NAME}" ,  'teh_membership'],
                                 [  'Recently added'    ,  'created_at'],
                                 ]


    @per_page_for_select =       [['5 organisations', '5'],
                                  ['10 organisations', '10'],
                                  ['50 organisations' , '50'],
                                  ['100 organisations' , '100']]

    if params[:reset] == 'all'
      # user have just entered the SEARCH menu, so we reset everything
      session[:template]              = nil
      session[:output]                = nil
      session[:selected_filter]       = nil
      session[:selected_organisation] = nil
      session[:selected_country]      = nil
      session[:selected_order]        = nil
      session[:selected_per_page]     = nil
      session[:selected_close_to_km]  = nil
      session[:selected_close_to_loc] = nil
      session[:selected_name]         = nil
      @selected_template = params[:template]
      @selected_output   = params[:output]
      @selected_filter   = default_filter
      @selected_per_page = default_per_page
      @search_action = search_organisations_url(:template => @selected_template, :output=> @selected_output)
      return
    end

    if params[:clear_session] == 'true'
      # if coming to the search page from someplaces else
      session[:template]              = nil
      session[:output]                = nil
      session[:selected_filter]       = nil
      session[:selected_organisation] = nil
      session[:selected_country]      = nil
      session[:selected_order]        = nil
      session[:selected_per_page]     = nil
      session[:selected_close_to_km]  = nil
      session[:selected_close_to_loc] = nil
      session[:selected_name]         = nil
    end
    #
    # Per tutti vale
    # session[:ciccio] = params(l'ha scelta) || session(la eredita) || (la prende di default)
    # @selected_ciccio = session[:ciccio]

    session[:template]              = params[:template]             || session[:template]               || default_template
    session[:output]                = params[:output]               || session[:output]                 || default_output
    session[:selected_filter]       = params[:filter]               || session[:selected_filter]        || default_filter
    session[:selected_organisation] = params[:filter_organisation]  || session[:selected_organisation]  || default_organisation
    session[:selected_country]      = params[:filter_country]       || session[:selected_country]       || default_country
    session[:selected_order]        = params[:order]                || session[:selected_order]         || default_order
    session[:selected_per_page]     = params[:per_page]             || session[:selected_per_page]      || default_per_page
    session[:selected_close_to_km]  = params[:filter_close_to_km]   || session[:selected_close_to_km]   || default_close_to_km
    session[:selected_close_to_loc] = params[:filter_close_to_loc]  || session[:selected_close_to_loc]  || default_close_to_loc
    session[:selected_name]         = params[:filter_name]          || session[:selected_name]          || default_name

    #
    @selected_template      = session[:template]
    @selected_output        = session[:output]
    @selected_filter        = session[:selected_filter]
    @selected_organisation  = session[:selected_organisation]
    @selected_country       = session[:selected_country]
    @selected_order         = session[:selected_order]
    @selected_per_page      = session[:selected_per_page]
    @selected_close_to_km   = session[:selected_close_to_km]
    @selected_close_to_loc  = session[:selected_close_to_loc]
    @selected_name          = session[:selected_name]

    unless @selected_template == 'only_results'
      # forzo template a basic/advanced, nel caso non ci siano o no valori
      #
      advanced_input =   @selected_organisation +
                            @selected_country +
                            @selected_close_to_km +
                            @selected_close_to_loc+
                            @selected_name

      if advanced_input.blank?
        @selected_template = 'basic'
      else
        @selected_template = 'advanced'
      end
    end
    
    #@search_action = "search?template=#{@selected_template}&output=#{@selected_output}"
    # ovvero:
    @search_action = search_organisations_url(:output=> @selected_output, :template => @selected_template)
    #
    unless @selected_close_to_loc.blank?
      @selected_close_to_loc.strip! #remove spaces
      #@location = MultiGeocoder.geocode(@selected_close_to_loc+', Europe')
      correction = @selected_country.capitalize+', Europe' || 'Europe'
      @location = GoogleGeocoder.geocode(@selected_close_to_loc+', '+correction)
      if @location.success && (@location.full_address != "Europe, ZZ")
        @selected_close_to_loc = @location.full_address
        @order_options_for_select.insert(0, ["Distance from location", 'distance'])
        if params[:order].nil? && session[:selected_order]==default_order
          @selected_order = 'distance'
        end
      else
        @location = nil
        flash.now[:error] = 'Unable to spot location', "System could not recognize the location: '#{@selected_close_to_loc}', check for spelling"
        @no_results = true
        return
      end
    end

    # MAP
    #if params[:output]=='map'
       @url_for_iframe = FACEBOOKER['callback_url'] +  "/iframe/iframe_organisations_map?"+
                                 "filter=#{@selected_filter}&" +
                                 "country=#{u(@selected_country)}&" +  # u() needed for spaces
                                 "organisation=#{u(@selected_organisation)}&" +
                                 "location_lat=#{@location.nil? ? 0 : u(@location.lat)}&" +
                                 "location_lng=#{@location.nil? ? 0 : u(@location.lng)}&" +
                                 "distance=#{@selected_close_to_km}&" +
                                 "location_full_address=#{u(@location.full_address) unless @location.nil?}&"+
                                 "searching_user_id=#{@current_user.id}&" +
                                 "name=#{@selected_name}"
      #return
    #end

    # search
    organisations = search_organisations_with(@current_user, {:filter => @selected_filter,
                                            :country => @selected_country,
                                            :organisation => @selected_organisation,
                                            :location => @location,
                                            :distance => @selected_close_to_km,
                                            :name => @selected_name})
    if organisations.size == 0
      @no_results = true
      return
    end
    # ORDER
    #
    if %w{country short_name city created_at teh_membership}.include? @selected_order
      # valido solo per le *colonne* di Organisation
      @ordered_organisations = organisations.sort_by {|organisation| organisation.send(@selected_order)}
      @ordered_organisations.reverse! if %w{teh_membership created_at}.include? @selected_order
    elsif @selected_order == 'distance'
      unless @location && @location.success # controllo di sicurezza
        flash[:error] = 'Internal Order Error', 'Trying to order on distance on a missing location'
        @no_results = true
        return
      end
      @ordered_organisations = organisations.sort_by {|organisation| organisation.distance_from(@location)}
    else
      flash[:error] = 'Order Error', 'Order not yet implemented'
      @no_results = true
      return
    end

    # PAGINATE
    #
    # per customizzazione will_paginate vedi:
    #http://www.pathf.com/blogs/2008/06/how-to-use-will_paginate-with-non-activerecord-collectionarray/@page_results = @posts.paginate(params[:current_page], params[:per_page])
    @page_results = @ordered_organisations.paginate(:page => params[:page], :per_page => @selected_per_page.to_i)
    # Results 4-6 of a total of 22
    # Results @item_start @item_end of a total of @item_total
    @item_start = @page_results.offset+1
    @item_total = @page_results.total_entries
    @item_end =  @page_results.offset+@page_results.per_page
    @item_end = @item_total if @item_end > @item_total
  end # search_organisations

end # main controller
