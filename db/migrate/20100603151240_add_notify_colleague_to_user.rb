class AddNotifyColleagueToUser < ActiveRecord::Migration
  def self.up
    add_column    :users,    :notify_colleague,  :boolean, :default => true
  end

  def self.down
    remove_column :users,    :notify_colleague
  end
end
