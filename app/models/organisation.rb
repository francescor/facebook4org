class Organisation < ActiveRecord::Base
  has_many :users, :dependent => :delete_all # deleting an organisation will set the foreign key in the user object to NULL
  has_many :organisation_posts, :dependent => :delete_all
  has_many :visits, :dependent => :delete_all
  #has_one  :accommodation, :dependent => :delete_all

  acts_as_mappable :default_units => :kms
  include GeoKit::Geocoders
  
  validates_uniqueness_of :name, :short_name
  # TODO (no, ARENA does not have locations... so better leave like this) add validation presence for :street after adding all TEH members
  validates_presence_of :name, :short_name, :homepage, :city # , :street
  validates_presence_of :country,
                        :message => 'must be selected'

  # vedi http://api.rubyonrails.org/classes/ActiveRecord/Base.html

  def name=(testo)
    # occhio che "".strip! è una operazione e può dare  NIL!, quindi non la puoi usare in cascata!!!!!!!
    testo = testo.to_s.strip
    testo = (testo.slice(0,1)).upcase+(testo.slice(1..-1)).to_s
    write_attribute(:name, testo)
  end

  def short_name=(testo)
    # occhio che "".strip! è una operazione e può dare  NIL!, quindi non la puoi usare in cascata!!!!!!!
    testo = testo.to_s.strip
    testo = (testo.slice(0,1)).upcase+(testo.slice(1..-1)).to_s
    write_attribute(:short_name, testo)
  end

  def city=(testo)
    # occhio che "".strip! è una operazione e può dare  NIL!, quindi non la puoi usare in cascata!!!!!!!
    testo = testo.to_s.strip
    testo = (testo.slice(0,1)).upcase+(testo.slice(1..-1)).to_s
    write_attribute(:city, testo)
  end

  def street=(testo)
    # occhio che "".strip! è una operazione e può dare  NIL!, quindi non la puoi usare in cascata!!!!!!!
    testo = testo.to_s.strip
    testo = (testo.slice(0,1)).upcase+(testo.slice(1..-1)).to_s
    write_attribute(:street, testo)
  end

  def homepage=(link)
    write_attribute(:homepage,  remove_eventual_http(link))
  end

  def teh_link=(link)
    write_attribute(:teh_link,  remove_eventual_http(link))
  end

  def facebook_link=(link)
    write_attribute(:facebook_link,  remove_eventual_http(link))
  end

  def image_link=(link)
    write_attribute(:image_link,  remove_eventual_http(link))
  end

  # for sorting: organisations_sorted = Organisation.all.sort
  def <=> (other_organisation)
    self.short_name <=> other_organisation.short_name
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

  def update_organisation_geo_info
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

  def increment_view_counter
    self.view_counter += 1
    self.save_with_validation(false)
  end

end
