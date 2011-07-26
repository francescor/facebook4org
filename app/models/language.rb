class Language < ActiveRecord::Base
  has_many :organisation_post_spoken_languages, :dependent => :delete_all
  has_many :user_spoken_languages, :dependent => :delete_all
end
