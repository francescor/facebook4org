class CronController < ApplicationController

 skip_before_filter       :ensure_application_is_installed_by_facebook_user,
                      :setup_db_user,
                      :ensure_organisation_is_set,
#                      :check_belonging_to_admission_group_and_update_admin_status,
                      :ensure_user_is_approved,
                      :ensure_user_have_signup_with_all_step
                    
  def notify_by_email
    # here we send all personal and general updates to users' email
    #   we need monthly, daily, weekly, hourly cron to the consecuent calls, 
    #   eg. for the WEEKLY cron we call
    #   http://localhost:3000/cron/notify_by_email?notification_by_email_every=week
    #   http://changingroom.archenet.it/cron/notify_by_email?notification_by_email_every=asap
    #   
    #   What do we send?
    #   following their notification_by_email_every choice... (week, day...)
    #   * we send COMMON notifications to all users that have choosen "Whenever there is a new event" (notify_notifications_for_all==1)
    #   * we send PERSONAL notifications to all users that have choosen "When new users working in my area sign-up"  or "When the MatchMaker find a match for me" (notify_match, notify_colleague ==1)
    # 
    # chiamata a notifications/cron_notify?days=week (asap, day, week, month)
    # http://localhost:3000/cron/notify_by_email?notification_by_email_every=week&
    @notification_by_email_every = params[:notification_by_email_every]
    # notify_match, notify_colleague, notify_notifications_for_all
#    @notify_match = params[:notify_match]
#    @notify_colleague = params[:notify_colleague]
#    @notify_notifications_for_all = params[:notify_notifications_for_all]
    #
    if NOTIFICATION_BY_EMAIL_EVERY_TYPES.map{|item| item[1]}.include? @notification_by_email_every
      # seleziono tutti gli utenti che sono:
      #    - regolarmente iscritti
      #    - che hanno fornito l'email
      #    - che hanno chiesto la notifica ogni @notification_by_email_every giorni
      users = User.all(:conditions => BASE_USER_FIND_CONDITIONS + " AND " +
                                            "email IS NOT NULL AND " +
                                            "(notification_by_email_every = '#{@notification_by_email_every}') ")
      #
      # ad ognuno invio una email con:
      #    - tutte le notifiche generali degli ultimi @notification_by_email_every giorni
      #
      common_notifications = Notification.all(:conditions => 'user_id IS NULL')
      if    @notification_by_email_every == 'asap' #hourly
        common_notifications = common_notifications.delete_if { |notification| ((Time.now - notification.date)/(60*60)) > 1 }
      elsif @notification_by_email_every == 'day'
        common_notifications = common_notifications.delete_if { |notification| ((Time.now - notification.date)/(60*60)) > 24 }
      elsif @notification_by_email_every == 'week'
        common_notifications = common_notifications.delete_if { |notification| ((Time.now - notification.date)/(60*60)) > (24*7) }
      elsif @notification_by_email_every == 'month'
        common_notifications = common_notifications.delete_if { |notification| ((Time.now - notification.date)/(60*60)) > (24*30) }
      else
        # pleonastico, ma messo in caso di errore
        common_notifications = []
      end
      
      common_message = ""
      common_notifications.each do |common_notification|
       common_message +=  '* '+common_notification.message+ '<br>'
      end
      
      counter_for_sent_email = 0
      users.each do |user|
        # remove all read notifications
        user_notifications = user.notifications.delete_if { |notification| notification.read}
        # pick just last notifications
        # nb (notification.date - Time.now)/60/60 è la differenza in ORE tra le due date
        if    @notification_by_email_every == 'asap' #hourly
          user_notifications = user_notifications.delete_if { |notification| ((Time.now - notification.date)/(60*60)) > 1 }
        elsif @notification_by_email_every == 'day'
          user_notifications = user_notifications.delete_if { |notification| ((Time.now - notification.date)/(60*60)) > 24 }
        elsif @notification_by_email_every == 'week'
          user_notifications = user_notifications.delete_if { |notification| ((Time.now - notification.date)/(60*60)) > (24*7) }
        elsif @notification_by_email_every == 'month'
          user_notifications = user_notifications.delete_if { |notification| ((Time.now - notification.date)/(60*60)) > (24*30) }
        else
          # pleonastico, ma messo in caso di errore
          user_notifications = []
        end

        specific_message = ''
        user_notifications.each do |user_notification|
         specific_message +=  '* '+user_notification.message+ '<br>'
        end
        message = ''
        #  we send COMMON notifications to all users that have choosen "Whenever there is a new event" (notify_notifications_for_all==1)
        if !common_message.blank? && user.notify_notifications_for_all
          message += "<p>#{common_message}</p>"
        end
        #   * we send PERSONAL notifications to all users that have choosen "When new users working in my area sign-up"  or "When the MatchMaker find a match for me" (notify_match, notify_colleague ==1)
        if !specific_message.blank? && (user.notify_match || user.notify_colleague)
          message += "<p>#{specific_message}</p>"
        end
        unless message.blank?
          # compose message for notification
          object = EMAIL_NOTIFICATION_OBJECT
          send_email_notification(user, message, object)
          counter_for_sent_email += 1
        end
      end

      @output = "#{Time.now}  cron/notify_by_email #{@notification_by_email_every.upcase} ok.   " + "N. #{counter_for_sent_email || 0} email sent, N. #{users.size} users. \n"
    else
      @output = "#{Time.now}  cron/notify_by_email ERROR on Cron #{@notification_by_email_every.upcase}.  \n"
    end
  end

end
