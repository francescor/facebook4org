class AddFieldToUser < ActiveRecord::Migration
  def self.up
    add_column    :users,    :cached_belongs_to_admission_group,    :boolean, :default => false
  end

  def self.down
    remove_column :users,    :cached_belongs_to_admission_group
  end
end
