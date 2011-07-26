users = User.find(:all)
counter_name = 0
counter_profile_url = 0
counter_pic_square = 0
users.each do |user|
  unless user.cached_name.blank?
    user.update_attribute(:cached_name,'')
    counter_name += 1
  end
  unless user.cached_profile_url.blank?
    user.update_attribute(:cached_profile_url,'')
    counter_profile_url += 1
  end
  unless user.cached_pic_square.blank?
    user.update_attribute(:cached_pic_square,'')
    counter_pic_square += 1
  end
end
if counter_name > 0
 print "Successfully resetted #{counter_name} names\n"
else
 print "no updates\n"
end
if counter_profile_url > 0
 print "Successfully resetted #{counter_profile_url} profile_urls\n"
else
 print "no updates\n"
end
if counter_pic_square > 0
 print "Successfully resetted #{counter_pic_square} pic_squares\n"
else
 print "no updates\n"
end
