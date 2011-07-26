class AddNotifyMatchToUser < ActiveRecord::Migration
  def self.up
    add_column    :users,    :notify_match,  :boolean, :default => true
  end

  def self.down
    remove_column :users,    :notify_match
  end
end
