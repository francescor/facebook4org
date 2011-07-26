class IndividualPost < ActiveRecord::Base
  belongs_to :user


  validates_presence_of :short_description

  validates_presence_of :category, :area, :duration,
                        :message => 'must be selected'
end
