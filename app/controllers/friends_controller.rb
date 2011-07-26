class FriendsController < ApplicationController
  layout 'main'

  def index
    @current_user_friend_uids = params[:fb_sig_friends].split(',')
    @friend_uids = @current_user_friend_uids
    @all_MM_user_uids = User.find(:all, :conditions => BASE_USER_FIND_CONDITIONS).map{|user| user.uid.to_s }
    @friend_uids_in_MM = @friend_uids & @all_MM_user_uids
    @friend_uids_not_in_MM = @friend_uids - @friend_uids_in_MM
  end

  def status
    @current_user_friend_uids = params[:fb_sig_friends].split(',')
    @friend_uids = @current_user_friend_uids
    @all_MM_user_uids = User.find(:all, :conditions => BASE_USER_FIND_CONDITIONS).map{|user| user.uid.to_s }
    @friend_uids_in_MM = @friend_uids & @all_MM_user_uids
    @friend_uids_not_in_MM = @friend_uids - @friend_uids_in_MM
  end
end
