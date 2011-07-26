class OrganisationPostSpokenLanguage < ActiveRecord::Base
  belongs_to :organisation_post
  belongs_to :language
end
