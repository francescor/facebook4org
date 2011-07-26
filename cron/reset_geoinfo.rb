print "\nUSERS\n"

users = User.find(:all)
counter = 0
users.each do |user|
  user.lat = 0.0
  user.lng = 0.0
  user.save
  counter += 1
end
if counter > 0
 print "Successfully resetted #{counter} locations\n"
else
 print "no updates\n"
end

print "\nORGANISATIONS\n"

organisations = Organisation.find(:all)
counter = 0
organisations.each do |organisation|
  organisation.lat = 0.0
  organisation.lng = 0.0
  organisation.save
  counter += 1
end
if counter > 0
 print "Successfully resetted #{counter} locations\n"
else
 print "no updates\n"
end
