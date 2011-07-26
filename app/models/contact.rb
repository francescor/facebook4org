class Contact < ActiveRecord::Base
  belongs_to :user
  belongs_to :contacted_user,  :class_name => "User"

end
