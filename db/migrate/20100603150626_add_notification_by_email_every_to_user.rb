class AddNotificationByEmailEveryToUser < ActiveRecord::Migration
  def self.up
    add_column    :users,    :notification_by_email_every,  :string, :default => 'week'
  end

  def self.down
    remove_column :users,    :notification_by_email_every
  end
end
