# My constants
  # CONSTANTS  customization STARTS HERE
  #APPLICATION_NAME = 'MatchMaker'
  APPLICATION_NAME = 'Facebook4org'
  # set the following to the ID of the administrator (or any other) facebook profile id
  FACEBOOK_ID_OF_THE_FB_USER_WHO_WILL_RECEIVE_FB_COMMENTS_NOTIFICATION = '757428004'
  APPLICATION_NAME_WITH_STYLE = "<b><font color='green'>#{APPLICATION_NAME}</font></b>"
  #APPLICATION_LONG_NAME = "<font color='green'>Changing Room - </font>#{APPLICATION_NAME}"
  APPLICATION_LONG_NAME = "<font color='green'>DEMO - </font>#{APPLICATION_NAME}"
  #APPLICATION_LONG_NAME_WITH_STYLE = "<font color='green'>Changing Room - </font>#{APPLICATION_NAME_WITH_STYLE}"
  APPLICATION_LONG_NAME_WITH_STYLE = "<font color='green'>DEMO - </font>#{APPLICATION_NAME_WITH_STYLE}"
  #APPLICATION_ID = '216038255084'
  APPLICATION_ID = '156784901011224'
  APPLICATION_INFO_LINK = "http://www.facebook.com/apps/application.php?id=#{APPLICATION_ID}"
  # in the following you can set CONTACT_US_LINK = APPLICATION_INFO_LINK
  #CONTACT_US_LINK = 'http://changingroom.teh.net/?page_id=14'
  CONTACT_US_LINK = APPLICATION_INFO_LINK
  #MAIN_ORG_NAME = "Trans Europe Halles"
  MAIN_ORG_NAME = "[Your Organiastion Name]"
 # MAIN_ORG_SHORT_NAME = "TEH"
  MAIN_ORG_SHORT_NAME = "[Your Org]"
  #MAIN_ORG_LINK = "http://www.teh.net"
  MAIN_ORG_LINK = "http://www.link_to_your_org.org"
  #SENDER_EMAIL_FOR_NOTIFICATIONS = '"'+APPLICATION_NAME+'" <do_not_answer@changingroom.teh.net>'
  SENDER_EMAIL_FOR_NOTIFICATIONS = '"'+APPLICATION_NAME+'" <do_not_answer@yourdomain.com>'
  ADMIN_GROUP_GID = '' # users belonging to this facebook group are automatically set with administrator rights
  ADMISSION_GROUP_GID = '5463607599' # this group is not used anymore: it was the old admission group for users
  # The following necessary for flash messages, but try to use <%= fb_grouplink(ADMISSION_GROUP_GID) %> as much as possible
  ADMISSION_GROUP_NAME = 'Trans Europe Halles'
  TOOLKIT_LINK = "http://changingroom.teh.net"
  TOOLKIT_NAME = "TOOLKIT"
  TOOLKIT_LINKED_NAME = "<a href=#{TOOLKIT_LINK}'>#{TOOLKIT_NAME}</a>"
  TOOLKIT_NAME_WITH_STYLE = "<font color='green'>Changing Room - </font>#{TOOLKIT_LINKED_NAME}"
  #
  CHANGING_ROOM_LINK = 'http://changingroom.teh.net'
  # add the email address you want to send detailed errors of the application
  EMAIL_RECIPIENT_FOR_ERRORS_NOTIFICATION = 'email@email.com'
  # the following for notification check
  EMAIL_BCC_RECIPIENT_FOR_ALL_NOTIFICATIONS = 'email@email.com'
  #
  # CONSTANTS  customization END HERE
