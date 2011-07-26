class AddNewRoleClassification < ActiveRecord::Migration
  def self.up
    add_column    :users,    :is_board_member,    :boolean, :default => nil
    add_column    :users,    :is_boss,            :boolean, :default => nil
    add_column    :users,    :is_manager,         :boolean, :default => nil
    add_column    :users,    :hours_as_worker,    :integer, :default => nil
    add_column    :users,    :hours_as_volunteer, :integer, :default => nil
  end

  def self.down
    remove_column :users,    :is_board_member
    remove_column :users,    :is_boss
    remove_column :users,    :is_manager
    remove_column :users,    :hours_as_worker
    remove_column :users,    :hours_as_volunteer
  end
end
