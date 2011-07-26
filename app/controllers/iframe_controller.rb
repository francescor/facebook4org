class IframeController < ApplicationController
 skip_before_filter   :ensure_application_is_installed_by_facebook_user,
                      :setup_db_user,
                      :ensure_organisation_is_set,
#                      :check_belonging_to_admission_group_and_update_admin_status,
                      :ensure_user_is_approved,
                      :ensure_user_have_signup_with_all_step

  def iframe_users_map
    # controllo ke non ci sia una chiamata diretta
    # Check whether referring URL comes from facebook
    # TODO metti in sicurezza ke uno può andarselo a scrivere nel proprio browser il referer url !
    # "http://apps.facebook.com/changingroom..."
    # http://ym4r.rubyforge.org/ym4r_gm-doc/
    referer = request.env["HTTP_REFERER"] # attento ke request.env[:HTTP_REFERER] e' un'altra cosa!
    if referer.nil? || referer[0,APPLICATION_CANVAS_URL.size] != APPLICATION_CANVAS_URL
      flash[:error] = "Error: you cannot access this page directly"
      @status = 'error'
    else
      @status = 'ok'
      # get users
      searching_user = User.find_by_id(params[:searching_user_id].to_i)
      @users = search_users_with(searching_user, { :filter        => params[:filter],
                                                   :country       => params[:country],
                                                   :organisation  => params[:organisation],
                                                   :gender        => params[:gender],
                                                   :go_as         => params[:go_as],
                                                   :location_lat  => params[:location_lat],
                                                   :location_lng  => params[:location_lng],
                                                   :distance      => params[:distance],
                                                   :job_area      => params[:job_area],
                                                   :job_role      => params[:job_role],
                                                   :friendship    => params[:friendship],
                                                   :name          => params[:name]})
      if @users.nil?
        flash[:error] = "Your search did not find any result"
        @status = 'error'
      else
        @users = @users.sort_by {|user| user.lng}
        location_lat = params[:location_lat].to_f
        location_lng = params[:location_lng].to_f
        location_full_address = params[:location_full_address]
        @map = GMap.new("map_div")
        @map.control_init(:large_map => true, :map_type => true)
        # create marker for the source location
        # Icons http://www.visual-case.it/cgi-bin/vc/GMapsIcons.pl
        #
#        @map.icon_global_init( GIcon.new(:image =>
#            "/images/map_icons/target.png",
#                  #:shadow => "/images/map_icons/red_pushpin.shadow.png",
#                  :icon_size => GSize.new(32,32),
#                  #:shadow_size => GSize.new(37,32),
#                  :icon_anchor => GPoint.new(9,32),
#                  :info_window_anchor => GPoint.new(20,6),
#                  :info_shadow_anchor => GPoint.new(18,25)),
#            "icon_location")
#        icon_location = Variable.new("icon_location")
        #
        if location_lat == 0 && location_lng == 0
          # zoom to the source
          @map_center_lat = MAP_CENTER_LAT
          @map_center_lng = MAP_CENTER_LNG
          @map_zoom = 3
          #@map.center_zoom_init([MAP_CENTER_LAT, MAP_CENTER_LNG], 3)
        else
          # zoom to the source
          @map_center_lat = location_lat
          @map_center_lng = location_lng
          @map_zoom = 6
          #@map.center_zoom_init([location_lat, location_lng], 6)
          source = GMarker.new([location_lat, location_lng],
                :title => location_full_address,
                :info_window => "This is <b>#{location_full_address}</b>"
                #:icon => icon_location
                )
          @map.overlay_init(source)
        end
        @map.center_zoom_init([@map_center_lat, @map_center_lng], @map_zoom)
        create_users_marker_for(@users, searching_user)
      end
    end
  end

  def iframe_user_map
    # controllo ke non ci sia una chiamata diretta
    # Check whether referring URL comes from facebook
    # TODO metti in sicurezza ke uno può andarselo a scrivere nel proprio browser il referer url !
    # "http://apps.facebook.com/changingroom..."
    referer = request.env["HTTP_REFERER"] # attento ke request.env[:HTTP_REFERER] e' un'altra cosa!
    if referer.nil? || referer[0,APPLICATION_CANVAS_URL.size] != APPLICATION_CANVAS_URL
      flash[:error] = "Error: you cannot access this page directly"
      @status = 'error'
    else
      @status = 'ok'
      # get users
      user = User.find_by_id(params[:user_id].to_i)
      users = Array.new
      users << user
      unless params[:user_id] == params[:searching_user_id]
        searching_user = User.find_by_id(params[:searching_user_id].to_i)
        users << searching_user
      end
      if users.nil?
        flash[:error] = "Your search did not find any result"
      else
        @map = GMap.new("map_div")
        # vedi http://ym4r.rubyforge.org/ym4r_gm-doc/
        # map_type: e' la scelta del tipo di mappa
        @map.control_init(:small_map => true, :map_type => false)
        @map.set_map_type_init(GMapType::G_HYBRID_MAP)
        #
        @map.center_zoom_init([user.lat, user.lng], 5)
        # create markers one for each location found
        create_users_marker_for(users, searching_user)
      end
    end
  end


  def create_users_marker_for(users, searching_user = nil)
    @map.icon_global_init( GIcon.new(:image =>
        "/images/map_icons/male_dark.png",
              :shadow => "/images/map_icons/male.shadow.png",
              :icon_size => GSize.new(32,32),
              :shadow_size => GSize.new(59,32),
              :icon_anchor => GPoint.new(15,32),
              :info_window_anchor => GPoint.new(15,6),  #x,y  x destra (al contrario), y giu
              :info_shadow_anchor => GPoint.new(18,25)),
        "icon_male")
    icon_male = Variable.new("icon_male")
    #
    @map.icon_global_init( GIcon.new(:image =>
        "/images/map_icons/female_dark.png",
              :shadow => "/images/map_icons/female.shadow.png",
              :icon_size => GSize.new(32,32),
              :shadow_size => GSize.new(59,32),
              :icon_anchor => GPoint.new(15,32),
              :info_window_anchor => GPoint.new(15,6),  #x,y  x destra (al contrario), y giu
              :info_shadow_anchor => GPoint.new(18,25)),
        "icon_female")
    icon_female = Variable.new("icon_female")
    #
    @map.icon_global_init( GIcon.new(:image =>
        "/images/map_icons/male.png",
              :shadow => "/images/map_icons/male.shadow.png",
              :icon_size => GSize.new(32,32),
              :shadow_size => GSize.new(59,32),
              :icon_anchor => GPoint.new(15,32),
              :info_window_anchor => GPoint.new(15,6),  #x,y  x destra (al contrario), y giu
              :info_shadow_anchor => GPoint.new(18,25)),
        "icon_you_male")
    icon_you_male = Variable.new("icon_you_male")
    #
    @map.icon_global_init( GIcon.new(:image =>
        "/images/map_icons/female.png",
              :shadow => "/images/map_icons/female.shadow.png",
              :icon_size => GSize.new(32,32),
              :shadow_size => GSize.new(59,32),
              :icon_anchor => GPoint.new(15,32),
              :info_window_anchor => GPoint.new(15,6),  #x,y  x destra (al contrario), y giu
              :info_shadow_anchor => GPoint.new(18,25)),
        "icon_you_female")
    icon_you_female = Variable.new("icon_you_female")
    #
   # create markers one for each location found
    markers = []
    previous_lng = 0
    users.each do |user|
      if user.lng == previous_lng
        user.lng += 0.002
      end
      previous_lng = user.lng
      #
      pic_url = user.cached_pic_square.blank? ? '/images/user_blank_pic_square.gif' : user.cached_pic_square
      user_url = APPLICATION_CANVAS_URL+"/users/#{user.id}"
      organisation_url = APPLICATION_CANVAS_URL+"/organisations/#{user.organisation.id}"
      info = "#{user.city}  #{user.country} "
      if user.infopoint == 'yes'
        info += "<img src='/images/user_infopoint_yes_icon.gif' title='Willing to give information about #{user.city.upcase}' />"
      end
      # http://code.google.com/apis/maps/documentation/reference.html#GMarker
      # http://mapki.com/wiki/Google_Map_Parameters
      case user.hosting
        when 'yes'
          info += "<img src='/images/user_hosting_yes_icon_small.gif'   title='Available for hosting'  />"
        when 'maybe'
          info += "<img src='/images/user_hosting_maybe_icon_small.gif' title='Maybe available for hosting' />"
        else
          info += "<img src='/images/user_hosting_no_icon_small.gif'    title='Not available for hosting' />"
      end
      info += "<br />"
      info += "Org: <a href='#{organisation_url}' target='_top'>#{user.organisation.short_name}</a>"
      name = (user == searching_user) ? 'You' : user.cached_name
      name = "see info" if name.blank?
      info_window = "<a href='#{user_url}' target='_top'><img src='#{pic_url}' title=#{name} class='pic_float' /></a>"+
                    "<a href='#{user_url}' target='_top'>#{name}</a><br />"+
                    info
      #
      if  user == searching_user || (users.size == 1 && searching_user.nil?)
        info_window += "<br /><div style ='font-size: 9px;'>Need a better spot? <a href='/users/#{user.id}/edit_profile' target='_top' style ='font-size: 9px;' >Update your address</a></div><br />"
        if user.gender == 'male'
            markers << GMarker.new([user.lat, user.lng], :icon => icon_you_male,    :title => name, :info_window => info_window)
        else
            markers << GMarker.new([user.lat, user.lng], :icon => icon_you_female,  :title => name, :info_window => info_window)
        end
      else
        if user.gender == 'male'
            markers << GMarker.new([user.lat, user.lng], :icon => icon_male,        :title => name, :info_window => info_window)
        else
            markers << GMarker.new([user.lat, user.lng], :icon => icon_female,      :title => name, :info_window => info_window)
        end
      end
    end
    @map.overlay_global_init(GMarkerGroup.new(true, markers),"user_markers")
  end

 def iframe_organisation_posts_map
    # controllo ke non ci sia una chiamata diretta
    # Check whether referring URL comes from facebook
    # TODO metti in sicurezza ke uno può andarselo a scrivere nel proprio browser il referer url !
    # "http://apps.facebook.com/changingroom..."
    # http://ym4r.rubyforge.org/ym4r_gm-doc/
    referer = request.env["HTTP_REFERER"] # attento ke request.env[:HTTP_REFERER] e' un'altra cosa!
    if referer.nil? || referer[0,APPLICATION_CANVAS_URL.size] != APPLICATION_CANVAS_URL
      flash[:error] = "Error: you cannot access this page directly"
      @status = 'error'
    else
      @status = 'ok'
      # get users
      searching_user = User.find_by_id(params[:searching_user_id].to_i)
      @organisation_posts = search_organisation_posts_with(searching_user, {:filter        => params[:filter],
                                                   :country       => params[:country],
                                                   :organisation  => params[:organisation],
                                                   :area          => params[:area],
                                                   :category      => params[:category],
                                                   :duration      => params[:duration],
                                                   :location_lat  => params[:location_lat],
                                                   :location_lng  => params[:location_lng],
                                                   :distance      => params[:distance]})
      if @organisation_posts.empty?
        flash[:error] = "Your search did not find any result"
        @status = 'error'
      else
        location_lat = params[:location_lat].to_f
        location_lng = params[:location_lng].to_f
        location_full_address = params[:location_full_address]
        @map = GMap.new("map_div")
        @map.control_init(:large_map => true, :map_type => true)
        # create marker for the source location
        # Icons http://www.visual-case.it/cgi-bin/vc/GMapsIcons.pl
        #
#        @map.icon_global_init( GIcon.new(:image =>
#            "/images/map_icons/target.png",
#                  #:shadow => "/images/map_icons/red_pushpin.shadow.png",
#                  :icon_size => GSize.new(32,32),
#                  #:shadow_size => GSize.new(37,32),
#                  :icon_anchor => GPoint.new(9,32),
#                  :info_window_anchor => GPoint.new(20,6),
#                  :info_shadow_anchor => GPoint.new(18,25)),
#            "icon_location")
#        icon_location = Variable.new("icon_location")
        #
        if location_lat == 0 && location_lng == 0
          # zoom to the source
          @map_center_lat = MAP_CENTER_LAT
          @map_center_lng = MAP_CENTER_LNG
          @map_zoom = 3
          #@map.center_zoom_init([MAP_CENTER_LAT, MAP_CENTER_LNG], 3)
        else
          # zoom to the source
          @map_center_lat = location_lat
          @map_center_lng = location_lng
          @map_zoom = 6
          source = GMarker.new([location_lat, location_lng],
                :title => location_full_address,
                :info_window => "This is <b>#{location_full_address}</b>"
                #:icon => icon_location
                )
          @map.overlay_init(source)
        end
        @map.center_zoom_init([@map_center_lat, @map_center_lng], @map_zoom)
        create_organisation_posts_marker_for(@organisation_posts, searching_user)
      end
    end
  end

  def iframe_organisation_post_map
    # controllo ke non ci sia una chiamata diretta
    # Check whether referring URL comes from facebook
    # TODO metti in sicurezza ke uno può andarselo a scrivere nel proprio browser il referer url !
    # "http://apps.facebook.com/changingroom..."
    # http://ym4r.rubyforge.org/ym4r_gm-doc/
    referer = request.env["HTTP_REFERER"] # attento ke request.env[:HTTP_REFERER] e' un'altra cosa!
    if referer.nil? || referer[0,APPLICATION_CANVAS_URL.size] != APPLICATION_CANVAS_URL
      flash[:error] = "Error: you cannot access this page directly"
      @status = 'error'
    else
      @status = 'ok'
      # get users
      searching_user = nil
      organisation_post = OrganisationPost.find_by_id(params[:organisation_post_id].to_i)
      organisation_posts = Array.new
      organisation_posts << organisation_post
      if organisation_posts.nil?
        flash[:error] = "Your search did not find any result"
        @status = 'error'
      else
        location_lat = params[:location_lat].to_f
        location_lng = params[:location_lng].to_f
        location_full_address = params[:location_full_address]
        @map = GMap.new("map_div")
        @map.control_init(:small_map => true, :map_type => false)
        @map.set_map_type_init(GMapType::G_HYBRID_MAP)
        # create marker for the source location
        # Icons http://www.visual-case.it/cgi-bin/vc/GMapsIcons.pl
        #
#        @map.icon_global_init( GIcon.new(:image =>
#            "/images/map_icons/target.png",
#                  #:shadow => "/images/map_icons/red_pushpin.shadow.png",
#                  :icon_size => GSize.new(32,32),
#                  #:shadow_size => GSize.new(37,32),
#                  :icon_anchor => GPoint.new(9,32),
#                  :info_window_anchor => GPoint.new(20,6),
#                  :info_shadow_anchor => GPoint.new(18,25)),
#            "icon_location")
#        icon_location = Variable.new("icon_location")
        #
        if location_lat == 0 && location_lng == 0
          # zoom to the source
          @map.center_zoom_init([organisation_post.organisation.lat, organisation_post.organisation.lng], 5)
        else
          # zoom to the source
          @map.center_zoom_init([location_lat, location_lng], 6)
          source = GMarker.new([location_lat, location_lng],
                :title => location_full_address,
                :info_window => "This is <b>#{location_full_address}</b>"
                #:icon => icon_location
                )
          @map.overlay_init(source)
        end
        create_organisation_posts_marker_for(organisation_posts, searching_user)
      end
    end
  end

  def create_organisation_posts_marker_for(organisation_posts, searching_user = nil)

    #
 
    #
   # create markers one for each location found
    markers = []
    previous_lng = 0
    organisation_posts.each do |organisation_post|
      if organisation_post.organisation.lng == previous_lng
        organisation_post.organisation.lng += 0.04
      end
      previous_lng = organisation_post.organisation.lng
      #
      organisation_post_url = APPLICATION_CANVAS_URL+"/organisation_posts/#{organisation_post.id}"
      organisation_url = APPLICATION_CANVAS_URL+"/organisations/#{organisation_post.organisation.id}"
      # http://code.google.com/apis/maps/documentation/reference.html#GMarker
      # http://mapki.com/wiki/Google_Map_Parameters
      info_window =  "Organisation: <a href='#{organisation_url}' target='_top'>#{organisation_post.organisation.short_name}</a><br />"
      info_window += "<img alt='#{organisation_post.organisation.short_name}' src='http://#{organisation_post.organisation.image_link}' height='50'  class='pic_float'  /><br />" unless organisation_post.organisation.image_link.blank?
      info_window += "(#{organisation_post.organisation.city} - #{organisation_post.organisation.country})<br />"
      info_window += "is looking for: <b>#{organisation_post.category}</b>, area: #{organisation_post.area_in_words}<br />"
      info_window += "when: <b>#{organisation_post.when.month}-#{organisation_post.when.year}</b><br />"
      info_window += "(duration: #{organisation_post.duration_in_words})<br />" unless organisation_post.duration == 0
      info_window += "<a href='#{organisation_post_url}' target='_top'>...more info</a>"
      #
      markers << GMarker.new([organisation_post.organisation.lat, organisation_post.organisation.lng], :title => organisation_post.organisation.short_name, :info_window => info_window)
    end
    @map.overlay_global_init(GMarkerGroup.new(true, markers),"organisation_post_markers")
  end


 def iframe_organisations_map
    # controllo ke non ci sia una chiamata diretta
    # Check whether referring URL comes from facebook
    # TODO metti in sicurezza ke uno può andarselo a scrivere nel proprio browser il referer url !
    # "http://apps.facebook.com/changingroom..."
    # http://ym4r.rubyforge.org/ym4r_gm-doc/
    referer = request.env["HTTP_REFERER"] # attento ke request.env[:HTTP_REFERER] e' un'altra cosa!
    if referer.nil? || referer[0,APPLICATION_CANVAS_URL.size] != APPLICATION_CANVAS_URL
      flash[:error] = "Error: you cannot access this page directly"
      @status = 'error'
    else
      @status = 'ok'
      # get users
      searching_user = User.find_by_id(params[:searching_user_id].to_i)
      @organisations = search_organisations_with(searching_user, {:filter        => params[:filter],
                                                   :country       => params[:country],
                                                   :organisation  => params[:organisation],
                                                   :area          => params[:area],
                                                   :category      => params[:category],
                                                   :duration      => params[:duration],
                                                   :location_lat  => params[:location_lat],
                                                   :location_lng  => params[:location_lng],
                                                   :distance      => params[:distance],
                                                   :name          => params[:name]})
      if @organisations.nil?
        flash[:error] = "Your search did not find any result"
        @status = 'error'
      else
        location_lat = params[:location_lat].to_f
        location_lng = params[:location_lng].to_f
        location_full_address = params[:location_full_address]
        @map = GMap.new("map_div")
        @map.control_init(:large_map => true, :map_type => true)
        # create marker for the source location
        # Icons http://www.visual-case.it/cgi-bin/vc/GMapsIcons.pl
        #
#        @map.icon_global_init( GIcon.new(:image =>
#            "/images/map_icons/target.png",
#                  #:shadow => "/images/map_icons/red_pushpin.shadow.png",
#                  :icon_size => GSize.new(32,32),
#                  #:shadow_size => GSize.new(37,32),
#                  :icon_anchor => GPoint.new(9,32),
#                  :info_window_anchor => GPoint.new(20,6),
#                  :info_shadow_anchor => GPoint.new(18,25)),
#            "icon_location")
#        icon_location = Variable.new("icon_location")
        #
        if location_lat == 0 && location_lng == 0
          # zoom to the source
          @map.center_zoom_init([MAP_CENTER_LAT, MAP_CENTER_LNG], 3)
        else
          # zoom to the source
          @map.center_zoom_init([location_lat, location_lng], 6)
          source = GMarker.new([location_lat, location_lng],
                :title => location_full_address,
                :info_window => "This is <b>#{location_full_address}</b>"
                #:icon => icon_location
                )
          @map.overlay_init(source)
        end
        create_organisations_marker_for(@organisations, searching_user)
      end
    end
  end

  def iframe_organisation_map
    # controllo ke non ci sia una chiamata diretta
    # Check whether referring URL comes from facebook
    # TODO metti in sicurezza ke uno può andarselo a scrivere nel proprio browser il referer url !
    # "http://apps.facebook.com/changingroom..."
    # http://ym4r.rubyforge.org/ym4r_gm-doc/
    referer = request.env["HTTP_REFERER"] # attento ke request.env[:HTTP_REFERER] e' un'altra cosa!
    if referer.nil? || referer[0,APPLICATION_CANVAS_URL.size] != APPLICATION_CANVAS_URL
      flash[:error] = "Error: you cannot access this page directly"
      @status = 'error'
    else
      @status = 'ok'
      # get users
      searching_user = User.find_by_id(params[:searching_user_id].to_i)
      organisation = Organisation.find_by_id(params[:organisation_id].to_i)
      organisations = Array.new
      organisations << organisation
      if organisations.nil?
        flash[:error] = "Your search did not find any result"
        @status = 'error'
      else
        location_lat = params[:location_lat].to_f
        location_lng = params[:location_lng].to_f
        location_full_address = params[:location_full_address]
        @map = GMap.new("map_div")
        @map.control_init(:small_map => true, :map_type => false)
        @map.set_map_type_init(GMapType::G_HYBRID_MAP)
        # create marker for the source location
        # Icons http://www.visual-case.it/cgi-bin/vc/GMapsIcons.pl
        #
#        @map.icon_global_init( GIcon.new(:image =>
#            "/images/map_icons/target.png",
#                  #:shadow => "/images/map_icons/red_pushpin.shadow.png",
#                  :icon_size => GSize.new(32,32),
#                  #:shadow_size => GSize.new(37,32),
#                  :icon_anchor => GPoint.new(9,32),
#                  :info_window_anchor => GPoint.new(20,6),
#                  :info_shadow_anchor => GPoint.new(18,25)),
#            "icon_location")
#        icon_location = Variable.new("icon_location")
        #
        if location_lat == 0 && location_lng == 0
          # zoom to the source
          @map.center_zoom_init([organisation.lat, organisation.lng], 5)
        else
          # zoom to the source
          @map.center_zoom_init([location_lat, location_lng], 6)
          source = GMarker.new([location_lat, location_lng],
                :title => location_full_address,
                :info_window => "This is <b>#{location_full_address}</b>"
                #:icon => icon_location
                )
          @map.overlay_init(source)
        end
        create_organisations_marker_for(organisations, searching_user)
      end
    end
  end

  def create_organisations_marker_for(organisations, searching_user = nil)

    #

    #
   # create markers one for each location found
    markers = []
    organisations.each do |organisation|
      #
      organisation_url = APPLICATION_CANVAS_URL+"/organisations/#{organisation.id}"
      # http://code.google.com/apis/maps/documentation/reference.html#GMarker
      # http://mapki.com/wiki/Google_Map_Parameters
      info_window =  "<a href='#{organisation_url}' target='_top'>#{organisation.short_name}</a><br />"
      unless searching_user.nil? || searching_user.organisation != organisation
        info_window += "(this is your organisation)<br />"
      end
      info_window += "<img alt='#{organisation.short_name}' src='http://#{organisation.image_link}' height='50'  class='pic_float'  /><br />" unless organisation.image_link.blank?
      info_window += "#{organisation.city} - <b>#{organisation.country}</b><br />"
      info_window += "web: <a href='http://#{organisation.homepage}' target='_top'>#{organisation.homepage}</a>"
      #
      markers << GMarker.new([organisation.lat, organisation.lng], :title => organisation.short_name, :info_window => info_window)
    end
    @map.overlay_global_init(GMarkerGroup.new(true, markers),"organisation_markers")
  end

end
