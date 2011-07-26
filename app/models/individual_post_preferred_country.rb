class IndividualPostPreferredCountry < ActiveRecord::Base
  belongs_to :individual_post
  belongs_to :country
end
