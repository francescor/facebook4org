class GeneralNotification < ActiveRecord::Base
  validates_presence_of :message
end
