class PersonalNotification < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :message
validates_presence_of :user_id
end
