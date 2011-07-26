users = User.find(:all, :conditions => 'signup_step > 1')

nil_name_users   = Array.new
blank_name_users = Array.new
nil_profile_url_users   = Array.new
blank_profile_url_users = Array.new
nil_pic_square_users   = Array.new
blank_pic_square_users = Array.new

users.each do |user|
  facebooker_user = user.best_basic_info_user

  new_name = facebooker_user.name
  new_profile_url = facebooker_user.profile_url
  new_pic_square = facebooker_user.pic_square

  if new_name == user.cached_name
    # nothing to do
    print "Same name for user: #{user.cached_name}\n"
  elsif new_name.blank?
    # new name is blank
    blank_name_users << user
  elsif new_name.nil?
    # new name is nil (not necessary  but...)
    nil_name_users << user
  else
    user.update_attribute(:cached_name, new_name)
    print "Cached name: #{new_name}\n"
  end

  if new_profile_url == user.cached_profile_url
    # nothing to do
    print "Same profile_url for user: #{user.cached_profile_url}\n"
  elsif new_profile_url.blank?
    # new profile_url is blank
    blank_profile_url_users << user
  elsif new_profile_url.nil?
    # new profile_url is nil (not necessary  but...)
    nil_profile_url_users << user
  else
    user.update_attribute(:cached_profile_url, new_profile_url)
    print "Cached profile_url: #{new_profile_url}\n"
  end

  if new_pic_square == user.cached_pic_square
    # nothing to do
    print "Same pic_square for user: #{user.cached_pic_square}\n"
  elsif new_pic_square.blank?
    # new pic_square is blank
    blank_pic_square_users << user
  elsif new_pic_square.nil?
    # new pic_square is nil (not necessary  but...)
    nil_pic_square_users << user
  else
    user.update_attribute(:cached_pic_square, new_pic_square)
    print "Cached pic_square: #{new_pic_square}\n"
  end

end

if nil_name_users.size+blank_name_users.size>0
  print "Problems with:\n"
else
  print "No problems while caching names\n"
end
if nil_name_users.size>0
  print "#{nil_name_users.size} nil_name users : "
  nil_name_users.each do |user|
    print "#{user.uid} \n"
  end
end
if blank_name_users.size>0
  print "#{blank_name_users.size} blank_name users : "
  blank_name_users.each do |user|
    print "#{user.uid} \n"
  end
end

if nil_profile_url_users.size+blank_profile_url_users.size>0
  print "Problems with:\n"
else
  print "No problems while caching profile_urls\n"
end
if nil_profile_url_users.size>0
  print "#{nil_profile_url_users.size} nil_profile_url users : "
  nil_profile_url_users.each do |user|
    print "#{user.uid} \n"
  end
end
if blank_profile_url_users.size>0
  print "#{blank_profile_url_users.size} blank_profile_url users : "
  blank_profile_url_users.each do |user|
    print "#{user.uid} \n"
  end
end

if nil_pic_square_users.size+blank_pic_square_users.size>0
  print "Problems with:\n"
else
  print "No problems while caching pic_squares\n"
end
if nil_pic_square_users.size>0
  print "#{nil_pic_square_users.size} nil_pic_square users : "
  nil_pic_square_users.each do |user|
    print "#{user.uid} \n"
  end
end
if blank_pic_square_users.size>0
  print "#{blank_pic_square_users.size} blank_pic_square users : "
  blank_pic_square_users.each do |user|
    print "#{user.uid} \n"
  end
end



