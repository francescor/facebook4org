class AddIsApprovedToUser < ActiveRecord::Migration
  def self.up
    add_column    :users,    :is_approved,    :boolean, :default => false
  end

  def self.down
    remove_column :users,    :is_approved
  end
end
