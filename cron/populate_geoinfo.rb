include GeoKit::Geocoders

print "\nUSERS\n"
users_with_empty_lat_and_lng = User.find_all_by_lat_and_lng(0,0)
counter = 0
users_with_empty_lat_and_lng.each do |user|
  old_address = user.address
  if user.update_user_geo_info
    print "User.id ##{user.id}\n Old '#{old_address}' \n New '#{user.address}'\n"
    counter += 1
  else
    print "no success updating user.id ##{user.id}\n  #{old_address}\n"
  end
end
if counter > 0
  print "Successfully updated #{counter} locations\n"
else
  print "no updates\n"
end
print "\nORGANISATIONS\n"

organisations_with_empty_lat_and_lng = Organisation.find_all_by_lat_and_lng(0,0)
counter = 0
organisations_with_empty_lat_and_lng.each do |organisation|
  old_address = organisation.address
  if organisation.update_organisation_geo_info
    print "organisation.id ##{organisation.id}\n Old '#{old_address}' \n New '#{organisation.address}'\n"
    counter += 1
  else
    print "no success updating organisation.id ##{organisation.id}\n  #{old_address}\n"
  end
end
if counter > 0
  print "Successfully updated #{counter} locations\n"
else
  print "no updates\n"
end