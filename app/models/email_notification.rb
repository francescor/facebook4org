class EmailNotification < ActionMailer::Base
 #
 # da http://www.devarticles.com/c/a/Ruby-on-Rails/Error-Checking-and-Debugging-with-Ruby-on-Rails/
 # excerpted from chapter 15 of the Ruby Cookbook, written by Lucas Carlson and Leonard Richardson (O'Reilly, 2006; ISBN: 0596523696)
  def error_message(exception, trace, session, params, env, sent_on = Time.now)
      @recipients    = EMAIL_RECIPIENT_FOR_ERRORS_NOTIFICATION
      @from          = SENDER_EMAIL_FOR_NOTIFICATIONS
      @subject       = "Error message on the #{APPLICATION_NAME}"
      # { env['REQUEST_URI']}"
      @sent_on       = sent_on
      @body = {
        :exception => exception,
        :trace => trace,
        :session => session,
        :params => params,
        :env => env
    }
  end

  def generic_email(message, recipient, object, sender)
    @recipients    = recipient  # 'oriettaxx@gmail.com' # CHANGE ALSO THE SUBJECT
    @from          = sender
    @subject       = object # + " (sent to you for debug; originally for: #{recipient})"
    @sent_on       = Time.now
    @body = {
      #:greeting => 'Hi,',
      :message => message
    }
    @bcc =  EMAIL_BCC_RECIPIENT_FOR_ALL_NOTIFICATIONS
#    unless indirizzo_bcc.nil?
#      @bcc =  indirizzo_bcc
#    end
  end

end