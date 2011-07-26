class User < ActiveRecord::Base
  has_many   :organisation_posts, :dependent => :delete_all
  has_many   :visits, :dependent => :delete_all
  has_many   :individual_posts, :dependent => :delete_all
  #has_one    :accommodation, :dependent => :delete_all
  has_many   :user_spoken_languages, :dependent => :delete_all
  has_many   :notifications, :dependent => :delete_all, :order => 'date DESC'
  belongs_to :organisation

  # contacts         = all contacts where this user is the contact actor:            his user.id is in the "user_id" field of contacts
  # inverse_contacts = all contacts where this user is been contacted by other user: his user.id is in the "contacted_user_id" field of contacts
  has_many   :contacts, :dependent => :delete_all # cancello ove l'utente è "user_id" in "contacts"
  has_many   :contacted_users, :through => :contacts # qui :dependent sarebbe ignorata
  # vedi railcast #163
  has_many   :inverse_contacts, :class_name => "Contact", :foreign_key => "contacted_user_id", :dependent => :delete_all# cancello ove l'utente è "contacted_user_id" in "contacts"
  has_many   :inverse_contacted_users, :through => :inverse_contacts, :source => :user# qui :dependent sarebbe ignorata

  acts_as_mappable :default_units => :kms
  include GeoKit::Geocoders

  before_create :setup_initial_admin

  def setup_initial_admin
    # set as admin the first user who sign-in
#    if User.find(:all).empty?
#      self.is_admin = true
      self.is_approved = true
#    end
  end

  def notifications_including_general
    Notification.find(:all, :conditions => "user_id=#{self.id} OR user_id IS NULL", :order => 'date DESC')
  end

  def notifications_unread
    Notification.find(:all, :conditions => {:user_id => self.id, :read => false}, :order => 'date DESC')
  end
  
  def inter_contacts
    # all contacts that have users either as been the actor, or as been contacted
    self.contacts + self.inverse_contacts
  end
  
  # vedi http://api.rubyonrails.org/classes/ActiveRecord/Base.html
  def city=(testo)
    write_attribute(:city, testo.capitalize)
  end

  def linkedin=(link)
    write_attribute(:linkedin, remove_eventual_http(link))
  end

  #
  #
  # Vedi http://github.com/digidigo/ruby_footprints/blob/master/app/models/facebook_user.rb
  #
  # NOTE on signup_step
  # SIGNUP_STEP change AFTER the below
  # signup_step = 0 (default) User has a facebook account and have hitted one page of the application and have allowed our application
  #       => can be deleted for DB maintainance (it's really hard we are here... since step 1 is automatic)
  # signup_step = 1 (auto)  the above + his initial profile have been CORRECTLY copied from facebook (we know where he comes from
  #       => can be deleted for DB maintainance
  #       => is the list of users who cannot access the application since they don't belong to the admitted group: can be contacted in case.
  # signup_step = 2  (edit_profile DONE!)  the above + user have CORRECTLY confirmed (maybe updated) his profile coming from facebook
  # signup_step = 3  (edit_preferences DONE!) the above + user have CORRECTLY entered all mandarory answer about his hosting/go profile
  #
  # validates_presence_of :go_as_worker, :go_as_volunteer, :go_as_intern, :infopoint
  # EDIT_PROFILE validation
  validates_numericality_of :age,
                            :greater_than_or_equal_to => 18,
                            :if => Proc.new { |user| user.signup_step >= 1 }
  validates_presence_of :email,
                        :if => Proc.new { |user| user.signup_step >= 1 },
                        :message => "is necessary (don't worry, it will stay inside #{MAIN_ORG_SHORT_NAME} and you may also choose to don't show it to other #{APPLICATION_NAME} users)"
  validates_presence_of :city, :job_description,
                        :if => Proc.new { |user| user.signup_step >= 1 }
  validates_presence_of :country, :age, :gender, :job_area,# :job_role,
                        :if => Proc.new { |user| user.signup_step >= 1 },
                        :message => 'must be selected'
#  validates_exclusion_of :job_area,
#                         :in => ["40"],
#                         :if => Proc.new { |user| user.signup_step >= 1 },
#                         :message => "is not valid. The #{APPLICATION_NAME} is not for artists, sorry"
  validates_exclusion_of :job_area,
                         :in => ["0"],
                         :if => Proc.new { |user| user.signup_step >= 1 },
                         :message => "is not valid. The #{APPLICATION_NAME} is just for individuals and organisations working in culture, sorry"

  # EDIT_PREFERENCES validation
  validates_presence_of :go_as_worker, :go_as_volunteer, :go_as_intern, :go_as_visitor, :hosting,
                        :message => 'must be selected',
                        :if => Proc.new { |user| user.signup_step >= 2 }
  validates_presence_of :infopoint, 
                        :message => 'must be selected',
                        :if => Proc.new { |user| user.signup_step >= 2 }
  #go_length == '--' || hosting == '--' || job_area == '--' || job_role == '--' || infopoint == '--'

  #  validates_presence_of :go_as_volunteer, :on => :update
  #  validates_presence_of :go_as_intern, :on =>  :update
  #  validates_presence_of :infopoint, :on => :update


  def is_pending
    if self.signup_step >=4 && !self.is_approved
      return true
    else
      return false
    end
  end
  
  # BEGIN ensure_create_user
  def self.ensure_create_user(uid)
    # Don't trust facebook to send a single request to you that
    # Initiates the creation of a row in the DB
    # This code ensures that you only get one row and that you don't
    # Get an exception
    user = nil
    begin
      user = self.find_or_initialize_by_uid(uid)
      if(user.new_record?)
        user.save!
      end
    rescue
      user = self.find_or_initialize_by_uid(uid)
      if(user.new_record?)
        user.save!
      end
    end
    raise "DidntCreateFBUser" unless user
    return user
  end
  # END ensure_create_user


  # Support to make the our model User delegate to the Facebooker::User
#  attr_accessor :facebooker_user
#  # BEGIN facebooker_user
#  def facebooker_user_
#    @facebooker_user ||= facebooker_session.user
#  end
#  # END facebooker_user


  attr_accessor :facebooker_session
  # BEGIN facebooker_session
  def facebooker_session
    # qui sta il trucco: creando una sessione legata all'utente self.uid
    # creo allo stesso tempo facebooker_session.user  che è un Facebooker::User
    # ovvero è un utente che posso interrogare direttamente in facebook, es. facebooker_session.user.name (!)
    # ma attenzione, è da chiamare SOLO per l'utente corrente, oppure quello che ha navigato negli ultimi 60 min
    #... non posso fare User.find(x).facebooker_user.name  <-- funziona solo negli ultimi 60 minuti
    # ma posso SEMPRE fare   User.find(current_user.id).facebooker_user.name
    # ovvero @current_user.facebooker_user.name
    unless @facebooker_session
      #logger.info("#{Time.now} created Facebooker::Session for user id: #{self.id}!")
      @facebooker_session = Facebooker::Session.create(ENV['FACEBOOK_API_KEY'], ENV['FACEBOOK_SECRET_KEY'])
      @facebooker_session.secure_with!(self.session_key,self.uid,1.hour.from_now)
      @facebooker_session.user.uid = self.uid
    end
    @facebooker_session
  end
  # END facebooker_session
#  def user
#    @user ||= facebooker_session.user
#  end

  # la seguente e' da utilizzare per consulte off-line
  # di MASSIMO ACCESSO
  # ovvero quando voglio dei dati (nome, friends...)
  # di un utente che non e' necessariamente quello che sta navigando
  # o addirittura per lavori off-line tipo cron
  #
  # per evitare chiamate API inutili operare in questo modo
  #  1. user = User.find(x).offline_access_user
  #  2. unless user.nil?
  #     user.name, user.sex... ecc.  così si fa una chiamata unica
  #  (se il risultato e' nil per sessione infinita mancante ...non si fanno API inutili)
  #
  #
  #  Uso Cron: Sì    metodo: qualsiasi (ma controlla non sia nil)
  #  Uso Web:  Sì    metodo: qualsiasi (ma controlla non sia nil)
  #  Performance:    Lenta (due chiamate), ma massimo del contenuto dei dati
  #
  def offline_access_user
    offline_session = Facebooker::Session.create(ENV['FACEBOOK_API_KEY'], ENV['FACEBOOK_SECRET_KEY'])
    offline_session.secure_with!(self.session_key,self.uid)
    if offline_session.expired?
      # even if I have permission and user is app user.. my session is expired... so ...nothing to do
      return nil
    else
      aus_user = Facebooker::User.new(self.uid)
      aus_user.session = Facebooker::Session.create(ENV['FACEBOOK_API_KEY'], ENV['FACEBOOK_SECRET_KEY'])
      # let's update our DB if "is_app_user" has changed
      if aus_user.is_app_user !=  self.is_my_app_user
        self.update_attribute(:is_my_app_user, aus_user.is_app_user)
      end
      # now we use the infinite session if we have one, but first we must check if is_app_user
      # and if we have 'offline_access' permissio
      if aus_user.is_app_user == '1' && aus_user.has_permission?('offline_access')
        offline_access_user = Facebooker::User.new(self.uid)
        offline_access_user.session = offline_session
        return offline_access_user
      else
        return nil
      end
    end
  end
  #
  # la seguente da utilizzare per ottenere il MASSIMO dei dati BASE da un utente
  # a costo di sacrificare ler performance (ugni chiamata TOP implica DUE chiamate API)
  # Se l'utente non ha privilegi top, viene restituita info di base
  #
  #  Uso Cron: Sì   metodo: SOLO per NOME, SEX ...ed altri basic (no friends)
  #  Uso web:  Sì   metodo: qualsiasi
  #  Performance:   Lenta (due chiamate), ma massimo del contenuto dei dati
  #
  def best_basic_info_user
    offline_access_user = self.offline_access_user
    if !offline_access_user.nil?
      return offline_access_user
    else
      basic_access_user = Facebooker::User.new(self.uid)
      if Facebooker::Session.current.nil?
        basic_access_user.session = Facebooker::Session.create(ENV['FACEBOOK_API_KEY'], ENV['FACEBOOK_SECRET_KEY'])
      end
      return basic_access_user
    end
  end
  #
  # Manca da creare
  # * chiamata per current_user (massimo privilegio)
  # * chiamata per generico utente da current_user (facciamo vedere SOLO quello che può vedere il current_user....non facciamo porcate!)
  # 
  #

  def facebook_app_user
    #controllo se un utente sta navigando (ovvero, mi accerto che non stia usandola in 'console'
    if Facebooker::Session.current.nil? 
      return nil
    else
      user = Facebooker::User.new(self.uid)
      if user.is_app_user == '1'
        return user
      else
        return nil
      end
    end
  end
 
  # la seguente è da utilizzare solo quando siamo sicuri che c'è un utente in linea
  # es. facebook_app_user_get('friend_ids')
  # MAI USATA FINO AD ORA
  def facebook_app_user_get(metodo) #
    #controllo se un utente sta navigando
    if facebook_app_user.nil?
        return ''
    else
        return facebook_app_user.send(metodo)
    end
  end

  def facebook_friend_uids_seen_from_current_user(current_user) # usata in users/show
    if self.uid == current_user.uid # check if current use is seeing himself
      return self.facebooker_session.user.friend_ids
    else # user is getting frinds of other user
      return self.facebook_friend_uids
    end
  end


  def facebook_friend_uids # usata qui sopra
    user = Facebooker::User.new(self.uid)
    # la seguente necessaria anche in run time... visto ke potremo aver appena creato 'user'
    user.session = APP_GENERIC_SESSION
    # la seguente necessaria altrimento ottendo un permission error (l'utente potrebbe aver rimosso la app)
    if user.is_app_user == '1' # TODO... a questo punto dovrei cancellare l'utente dal mio DB
      return user.friend_ids
    else
      return [] #empty array
    end
  end

  def facebook_friend_uids_in_common_with_current_user(current_user)
    uids1=current_user.facebook_friend_uids_seen_from_current_user(current_user)
    uids2=self.facebook_friend_uids
    return uids1 & uids2 # Returns a new array containing elements common to the two arrays, with no duplicates
  end

  def facebook_friend_uids_in_common_with_user(user)
    uids1=user.facebook_friend_uids
    uids2=self.facebook_friend_uids
    return uids1 & uids2 # Returns a new array containing elements common to the two arrays, with no duplicates
  end

  def address
    address =''
    address += "#{self.street}, "    unless self.street.blank?
    address += "#{self.city}, "      unless self.city.blank?
    address += "#{self.post_code}, " unless self.post_code.blank?
    address += "#{self.state}, "     unless self.state.blank?
    address += "#{self.country}"     unless self.country.blank? # btw, country cannot be blank
    return address
  end

  def get_geocoder_location
    loc = GoogleGeocoder.geocode(self.address)
    return loc
  end

  def update_user_geo_info
    loc = self.get_geocoder_location
    if loc.success
      self.lat = loc.lat
      self.lng = loc.lng
      self.post_code = loc.zip   if (self.post_code.blank? && !loc.zip.blank?  )
      self.state =     loc.state if (self.state.blank?     && !loc.state.blank? )
      self.save_with_validation(false)
      return true
    else
      return false
    end
  end

  # BEGIN method_missing
#  def method_missing(symbol , *args)
#    begin
#      value = super
#    rescue NoMethodError => err
#      if(user.respond_to?(symbol))
#        # nuova
#        #user.session = APP_GENERIC_SESSION
#        #
#        value = user.send(symbol,*args)
#        return value
#      else
#        throw err
#      end
#    end
#  end
  # END method_missing

  #
  #


  def notification_by_email_every_in_words
    risultato = ""
    NOTIFICATION_BY_EMAIL_EVERY_TYPES.each do |x|
      if notification_by_email_every == x[1]
        risultato = x[0]
      end
    end
    risultato
  end

  def hosting_in_words
    risultato = ""
    HOSTING_TYPES.each do |x|
      if hosting == x[1]
        risultato = x[0]
      end
    end
    risultato
  end

  def age_in_words
    risultato = ""
    AGE_TYPES.each do |x|
      if age == x[1]
        risultato = x[0]
      end
    end
     risultato
  end

  def job_role_in_words # attenzione che viene usato anche per l'ordinamento
    risultato = ""
    JOB_ROLE_TYPES.each do |x|
      if job_role == x[1]
        risultato = x[0]
      end
    end
    return risultato
  end


  def is_board_member_in_words
    risultato = ""
    YES_NO_TYPES.each do |x|
      if is_board_member == x[1]
        risultato = x[0]
      end
    end
    return risultato
  end


  def is_boss_in_words
    risultato = ""
    YES_NO_TYPES.each do |x|
      if is_boss == x[1]
        risultato = x[0]
      end
    end
     risultato
  end

 def is_manager_in_words
    risultato = ""
    YES_NO_TYPES.each do |x|
      if is_manager == x[1]
        risultato = x[0]
      end
    end
     risultato
  end

 def hours_as_worker_in_words
    risultato = ""
    HOURS_A_WEEK_TYPE.each do |x|
      if hours_as_worker == x[1]
        risultato = x[0]
      end
    end
     risultato
  end

 def hours_as_volunteer_in_words
    risultato = ""
    HOURS_A_WEEK_TYPE.each do |x|
      if hours_as_volunteer == x[1]
        risultato = x[0]
      end
    end
     risultato
  end

  def job_area_in_words # attenzione che viene usato anche per l'ordinamento
    risultato = ""
    JOB_AREA_TYPES.each do |x|
      if job_area == x[1]
        risultato = x[0]
      end
    end
    return risultato
  end

  def go_as_worker_in_words
    risultato = ""
    GO_AS_TYPES.each do |x|
      if go_as_worker == x[1]
        risultato = x[0]
      end
    end
     risultato
  end
  
 def go_as_volunteer_in_words
    risultato = ""
    GO_AS_TYPES.each do |x|
      if go_as_volunteer == x[1]
        risultato = x[0]
      end
    end
     risultato
  end

  def go_as_intern_in_words
    risultato = ""
    GO_AS_TYPES.each do |x|
      if go_as_intern == x[1]
        risultato = x[0]
      end
    end
     risultato
  end

  def go_as_visitor_in_words
    risultato = ""
    GO_AS_VISITOR_TYPES.each do |x|
      if go_as_visitor == x[1]
        risultato = x[0]
      end
    end
     risultato
  end

  def go_as_worker_duration_in_words
    risultato = ""
    DURATION_TYPES.each do |x|
      if go_as_worker == x[1]
        risultato = x[0]
      end
    end
     risultato
  end

 def go_as_volunteer_duration_in_words
    risultato = ""
    DURATION_TYPES.each do |x|
      if go_as_volunteer == x[1]
        risultato = x[0]
      end
    end
     risultato
  end

  def go_as_intern_duration_in_words
    risultato = ""
    DURATION_TYPES.each do |x|
      if go_as_intern == x[1]
        risultato = x[0]
      end
    end
     risultato
  end

  def birthday_month_in_words
    risultato = ""
    BIRTHDAY_MONTH_TYPES.each do |x|
      if birthday_month == x[1]
        risultato = x[0]
      end
    end
    risultato
  end

  def increment_view_counter
    self.view_counter += 1
    self.save_with_validation(false)
  end

  def validate

    # validazione email  http://www.buildingwebapps.com/articles/79182-validating-email-addresses-with-ruby
    unless email.blank?
        unless email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
            errors.add(:email, ": Your email address does not appear to be valid")
        end
    end

    # validates_presence_of :hosting, :job_area, :job_role, :infopoint
#    if go_length == '--' || hosting == '--' || job_area == '--' || job_role == '--' || infopoint == '--'
#       errors.add_to_base('Please aswer all questions marked with "*"')
#    end
  end
end
