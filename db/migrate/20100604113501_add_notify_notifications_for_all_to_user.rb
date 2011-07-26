class AddNotifyNotificationsForAllToUser < ActiveRecord::Migration
  def self.up
    add_column    :users,    :notify_notifications_for_all,  :boolean, :default => false
  end

  def self.down
    remove_column :users,    :notify_notifications_for_all
  end
end
