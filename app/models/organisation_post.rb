class OrganisationPost < ActiveRecord::Base
  belongs_to  :organisation  #(necessario, in quanto NON lo posso ricavare dal gruppo di user.. dato ke potrebbe appartenere a diversi gruppi.)
  belongs_to  :user
  has_many    :organisation_post_spoken_languages, :dependent => :delete_all

  validates_presence_of :short_description
  validates_presence_of :duration, :area, :category, :message => 'must be selected'
  validates_numericality_of :duration, :greater_than => 0, :message => 'must be selected'
  
  def duration_in_words
    risultato = ""
    ORGANISATION_POST_DURATION_TYPES.each do |x|
      if duration.to_i == x[1].to_i
        risultato = x[0]
      end
    end
    return risultato
  end

  def when_in_words
    if self.when.nil?
      return ''
    else
      return self.when.to_time.strftime("%B %Y")
    end
  end

  def area_in_words # attenzione che viene usato anche per l'ordinamento
    risultato = ""
    ORGANISATION_POST_AREA_TYPES.each do |x|
      if area == x[1]
        risultato = x[0]
      end
    end
    return risultato
  end

  def category_in_words # attenzione che viene usato anche per l'ordinamento
    risultato = ""
    ORGANISATION_POST_CATEGORY_TYPES.each do |x|
      if category == x[1]
        risultato = x[0]
      end
    end
    return risultato
  end

end
