users = User.find(:all, :conditions => 'signup_step = 3')


print "Permissions:\n\n"
contatore_email = 0
contatore_offline_access = 0
users.each do |user|
  #if user.facebooker_session.user.isAppUser
    print "User #{user.uid} - #{user.name}: \n"
    @email = user.facebooker_session.user.has_permission? :email
    @offline_access = user.facebooker_session.user.has_permission? :offline_access
    contatore_email += 1 if @email
    contatore_offline_access += 1 if @offline_access
    print "Email: #{@email}\n"
    print "Of-ac: #{@offline_access}\n\n"
  #end
end
print "\n\n"
print "Contatore email: #{contatore_email}\n"
print "Contatore offline_access: #{contatore_offline_access}\n"
print "Totale utenti: #{users.size}"
