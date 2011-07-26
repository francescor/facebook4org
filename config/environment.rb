# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present

RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  #
  # aggiunto per will paginate
  #config.gem "will_paginate"
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Rome'
  # nb, il DB quando scrive trasforma le date in UTC (ora del server mysql),
  # con Timenow mostra l'ora che qui iposto.
  # insomma, con questa impostazione è tutto ok, ma il TEMPO nel DB viene salvato in UTC, quindi per vedere gli utenti loggati
  # vedo quelli per cui il :last_login è meno di un'ora da Time.now.utc

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  #
  # La seguente necessaria a facebooker, vedi mangino p.39
  config.action_controller.allow_forgery_protection    = false
  
  # Aggiunto per abilitare sessioni in DB
  config.action_controller.session_store = :active_record_store
  #
  # Aggiunto per Geokit
  # vedi http://geokit.rubyforge.org/
  config.gem "geokit"
  # 
end

# aggiunto per will paginate
require 'will_paginate'
#
# Activate Mailer - Agile p. 505
# aggiunto per spedire notifiche di errore

ActionMailer::Base.delivery_method = :sendmail
# if you deploy  to heroku you can very easily enable email by adding the following line
# ActionMailer::Base.delivery_method = :smtp
# and then with the command: heroku addons:add sendgrid:free
# see http://docs.heroku.com/sendgrid

ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_charset = "utf-8"




  # load basic custom environment
  #require 'config/environment_for_matchmaker'
  #require 'config/environment_for_demo'
  require 'config/environment_personal'

  #
  ANWS = APPLICATION_NAME_WITH_STYLE
  AN = APPLICATION_NAME
  MAIN_ORG_NAME_LINKED = "<a href='#{MAIN_ORG_LINK}'>#{MAIN_ORG_NAME}</a>"
  MAIN_ORG_SHORT_NAME_LINKED = "<a href='#{MAIN_ORG_LINK}'>#{MAIN_ORG_SHORT_NAME}</a>"
  MOSNL = MAIN_ORG_SHORT_NAME_LINKED
  # the following always works (so development/production Facebook settings are updated automatically)
  # but it does not work with heroku deployment... so for heroku write it by hand
  if defined?(FACEBOOKER)
    FB_CANVAS_PAGE_NAME = FACEBOOKER['canvas_page_name']
    FB_CALLBACK_URL = FACEBOOKER['callback_url']
  else
    FB_CANVAS_PAGE_NAME = 'my_application'  # i.e. 'changingroom'
    FB_CALLBACK_URL = 'http://www.myserver.it' # i.e. 'http://www.myserver.it'
  end
  # in canvas I use "/", but in iframe I use:
  APPLICATION_CANVAS_URL = 'http://apps.facebook.com/'+FB_CANVAS_PAGE_NAME
  # in iframe I use "/", but in canvas I use:
  APPLICATION_CALLBACK_URL = FB_CALLBACK_URL
  ADMISSION_GROUP_LONG_NAME = "#{ADMISSION_GROUP_NAME} Facebook group"
  ADMISSION_GROUP_LINK = "http://www.facebook.com/group.php?gid=#{ADMISSION_GROUP_GID}"
  ADMISSION_GROUP_LINKED_NAME = "<a href='#{ADMISSION_GROUP_LINK}'>#{ADMISSION_GROUP_LONG_NAME}</a>"
  MAP_CENTER_LAT = 50.2022203 # Praha @lng=14.6765786, @lat=50.2022203
  MAP_CENTER_LNG = 14.6765786
  BASE_ORGANISATION_POST_FIND_CONDITIONS = " true" # put = " 1" for none
  BASE_ORGANISATION_FIND_CONDITIONS = " true"
  BASE_USER_FIND_CONDITIONS = "signup_step >= 3" #used in search
  STANDARD_INDIVIDUAL_USER_FIND_CONDITIONS = BASE_USER_FIND_CONDITIONS
  # the following condition necessary to work with Heroku
  if defined?(Facebooker)
    APP_GENERIC_SESSION = Facebooker::Session.create(ENV['FACEBOOK_API_KEY'], ENV['FACEBOOK_SECRET_KEY'])
  end
  MAX_FRIENDS_PIC_TO_SHOW = 35
  EMAIL_NOTIFICATION_OBJECT = "Notification from the #{APPLICATION_NAME}"
  EMAIL_NOTIFICATION_TEXT_TOP = "<h2>Notifications from the #{APPLICATION_NAME}</h2>"
  EMAIL_NOTIFICATION_TEXT_BOTTOM = "<br /><p><small>To change your preferences for notifications see <a href='#{APPLICATION_CANVAS_URL}/edit_notification_preferences'>#{APPLICATION_CANVAS_URL}/edit_notification_preferences</a></small></p><p>The <a href='#{APPLICATION_CANVAS_URL}'>#{APPLICATION_NAME}</a><br/><br/><a href='#{APPLICATION_CANVAS_URL}'><img  style='border:0px' src = http://changingroom.archenet.it/images/toolkit_logo.jpg ></a></p>"
  # TYPES
  # note: use numbers for "codes" when
  #    * you need some kind of ORDERING (when the order of codes in not enough)
  #    * content of single records may change in time
  #    * text in "code" may be too long

  NOTIFICATION_BY_EMAIL_EVERY_TYPES = [
                                       [  "every day"            , "day"   ],
                                       [  "once a week"          , "week"  ],
                                       [  "once a month"         , "month" ],
                                       [  "as soon as possible"  , "asap"  ],
                                       [  "never"                , "never" ],
                                       ]

  BIRTHDAY_DAY_TYPES = [['--',0]]+(1..31).map {|x| [x,x]}
  BIRTHDAY_MONTH_TYPES = [['--select--',0]]+
                          [['January', 1],
                          ['February', 2],
                          ['March',    3],
                          ['April',    4],
                          ['May',      5],
                          ['June',     6],
                          ['July',     7],
                          ['August',   8],
                          ['September',9],
                          ['October', 10],
                          ['November',11],
                          ['December',12]]
  MAIN_ORG_MEMBERSHIP_TYPES = [
                       [  ""        , ""],
                       [  "Member"  , "member"],
                       [  "friend"  , "friend"]]

  EXCHANGE_TYPES = [["--Select availability as:", ''],  # only used in search form till now
                                        ["As a Worker"          , 'worker'],
                                        ['As a Volunteer'       , 'volunteer'],
                                        ['As an Intern/Trainee' , 'intern'],
                                        ['For a short visit'    , 'visitor']]
  ORGANISATION_POST_CATEGORY_TYPES =[
                ["--Select--"                       , ""],
                ["a Worker"                         , "worker"],
                ["a Volunteer"                      , "volunteer"],
                ["an Intern/Trainee"                , "intern"],
                ["An exchange with an organisation" , "exchange"],
                ["Other"                            , "other"]]


  HOSTING_TYPES =[
                ["--Select--", ""],
                ["Yes", "yes"],
                ["Maybe", "maybe"],
                ["No", "no"]]
 
  ORGANISATION_POST_AREA_TYPES = [
                ["--Select Area:", ""],
                ["Management - (including boards)"              , "90"],
                ["Administration/Finance"                       , "85"],
                ["Programming/Curating and/or producing"         , "80"],
                ["Marketing & communications"                   , "73"],
                ["Box office"                                   , "70"],
                ["Technical"                                    , "65"],
                ["IT-computers/internet"                        , "63"],
                ["Consulting and/or training"                   , "60"],
                ["Education and/or outreach"                    , "55"],
                ["Catering and/or retail"                       , "50"],
                ["Research"                                     , "45"]]

  JOB_AREA_TYPES = ORGANISATION_POST_AREA_TYPES + [
                #["I am an artist"                               , "40"], # attenzione a correggere validazione in caso di variazione
                ["None of the above, I do not work in culture"  , "0"]]  # attenzione a correggere validazione in caso di variazione

  JOB_ROLE_TYPES =[
                ["--Select Job Role", ""],
                ["Board/Committee member", "90"],
                ["Director"              , "80"],
                ["Manager"               , "70"],
                ["Officer"               , "60"],
                ["Assistant"             , "50"],
                ["Intern"                , "40"],
                ["Volunteer"             , "20"],
                ["I'm a student"         , "10"]]

  # la seguente e' la stessa, sia per gli Users che per gli OrganisationPosts

  DURATION_TYPES =[
                                      ["Up to one week"      , 7],
                                      ["Up to one month"     , 30],
                                      ["Up to six months"    , 180],
                                      ["More then six months", 181]]

  HOURS_A_WEEK_TYPE = [[ "--Select--"                 , ""],
                                      ["0 hours a week"        , 0 ],
                                      ["up to 7 hours per week"      , 7 ],
                                      ["8 to 20 hours per week"      , 20],
                                      ["21 to 30 hours per week"     , 30],
                                      ["more then 30 hours per week" , 31]
                                    ]

  FRIENDSHIP_TYPES = [
                       [  ""                            , ""],
                       [  "Friends"                     , "friends"],
                       #[  "Friends or friends of friends", "fof"],
                       [  "Non-friends"                 , "non-friends"]
                       ]

  ORGANISATION_POST_DURATION_TYPES  = [["--Select--"          , 0]] +
                                      DURATION_TYPES

  my_array =    [[ "--Select--"          , ""   ]]

  DURATION_TYPES.each do |x|
    my_array += [[ 'Yes, '+x[0].downcase , x[1] ]]
  end

  my_array +=   [[ "No"                  , 0    ]]

  GO_AS_TYPES = my_array

  # ne risulta che
  #
  #  GO_AS_TYPES = [["--Select--"               , 0]]
  #                ["Yes, up to one week"      , 7],
  #                ["Yes, up to one month"     , 30],
  #                ["Yes, up to six months"    , 180],
  #                ["Yes, more than six months", 181],
  #                ["No"                       , 0]]

  GO_AS_VISITOR_TYPES =  [["--Select--", ""],
                      ["Yes", 1],
                      ["No", 0]]

  YES_NO_TYPES =  [["--Select--", ""],
                      ["Yes", true],
                      ["No", false]]

  COUNTRIES_AND_CODES  =[
                #["--Select Country:",      ""] see below for this one,
                # TAKE CARE when changing values here on the left (you then need to manually update records)
                ["Austria",                "AT"],
                ["Belarus",                "BY"],
                ["Belgium",                "BE"],
                ["Bosnia and Herzegovina", "BA"],
                ["Bulgaria",               "BG"],
                # TAKE CARE when changing values here on the left (you then need to manually update records)
                ["Czech Republic",         "CZ"],
                ["Denmark",                "DK"],
                ["Estonia",                "EE"],
                ["Finland",                "FI"],
                ["France",                 "FR"],
                # TAKE CARE when changing values here on the left (you then need to manually update records)
                ["Georgia",                "GE"],
                ["Germany",                "DE"],
                ["Gibraltar",              "GI"],
                ["Greece",                 "GR"],
                # TAKE CARE when changing values here on the left (you then need to manually update records)
                ["Greenland",              "GL"],
                ["Hungary",                "HU"],
                ["Iceland",                "IS"],
                ["Ireland",                "IE"],
                ["Italy",                  "IT"],
                ["Latvia",                 "LV"],
                ["Liechtenstein",          "LI"],
                ["Lithuania",              "LT"],
                # TAKE CARE when changing values here on the left (you then need to manually update records)
                ["Luxembourg",             "LU"],
                ["Malta",                  "MT"],
                ["Moldova, Republic of",   "MD"],
                ["Montenegro",             "ME"],
                ["Netherlands",            "NL"],
                ["Norway",                 "NO"],
                ["Poland",                 "PL"],
                ["Portugal",               "PT"],
                ["Romania",                "RO"],
                # TAKE CARE when changing values here on the left (you then need to manually update records)
                ["Russian Federation",     "RU"],
                ["Serbia",                 "RS"],
                ["Slovakia",               "SK"],
                ["Slovenia",               "SI"],
                ["Spain",                  "ES"],
                ["Sweden",                 "SE"],
                ["Switzerland",            "CH"],
                # TAKE CARE when changing values here on the left (you then need to manually update records)
                ["Turkey",                 "TR"],
                ["Ukraine",                "UA"],
                ["United Kingdom",         "GB"]]
  my_array = [["--Select Country:",      ""]]
  #COUNTRY_TYPES = COUNTRIES_AND_CODES.map {|x,y| [x,x]}
  COUNTRIES_AND_CODES.each {|x,y| my_array << [x,x]}
  COUNTRY_TYPES = my_array
  ##
  GENDER_TYPES =[
                ["--Select Sex:", ""],
                ["Female", "female"],
                ["Male"  , "male"]]
  AGES = [
                ["under 18", 0,  0..17 ],   #better if we use integer (for validation and of age prossimity)
                ["18-25"   , 18, 18..25],
                ["25-35"   , 25, 25..35],
                ["35-55"   , 35, 35..55],
                ["over 55" , 55, 55..100]]
  CLOSE_TO_KM_TYPES =[
                ["--Select distance:", ""],
                ["10"  , "10"],
                ["30"  , "30"],
                ["50"  , "50"],
                ["100" , "100"],
                ["250" , "250"]]
  CLOSE_TO_KM_DAILY_TRIP = CLOSE_TO_KM_TYPES[5][1].to_i # must be a value of CLOSE_TO_KM_TYPES
  my_array = [["--Select Age:", ""]]
  AGES.each {|x| my_array << [x[0],x[1]]}
  AGE_TYPES = my_array
  #
  def age_to_code(age)
  # i.e. age_to_code(41) => 35 (integer)
   code = 0
    AGES.each  do |x|
      code = x[1] if x[2].include?(age)
      end
    return code
  end


  ACCOMODATION_TYPES =[
                ["--Select--", ""],
                ["Bed/coach"        , "20"],
                ["Room"             , "30"],
                ["House/apartment"  , "40"],
                ["Other"            , "50"]]
  ACCOMMODATION_STATUS_TYPES=[
                ["Available"                , "ok"],
                ["Temporary non available"  , ""]]
  #
  INDIVIDUAL_POST_KINDS =[
                ["--Select--"     , ""],
                ["Job"            , "job"],
                ["Volunteer"      , "volunteer"],
                ["Internship"     , "internship"],
                ["Exchange"       , "exchange"],
                ["First Visit"    , "first visit"],
                ["Other"          , "other"]]

def remove_eventual_http(link)
  cleaned_link = link.to_s.strip
  cleaned_link = cleaned_link[0,7] != "http://" ? cleaned_link : cleaned_link[7,cleaned_link.length]
  cleaned_link = cleaned_link[0,6] != "http//" ?  cleaned_link : cleaned_link[6,cleaned_link.length]
  cleaned_link = cleaned_link[0,6] != "http:/" ?  cleaned_link : cleaned_link[6,cleaned_link.length]
  return cleaned_link
end
