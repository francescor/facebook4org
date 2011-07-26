class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users,    :lat,                 :float,   :default => 0.0, :null => false
    add_column :users,    :lng,                 :float,   :default => 0.0, :null => false
    add_column :users,    :is_my_app_user,      :string,  :default => '0', :null => false
    add_column :users,    :cached_name,         :string,  :default => '',  :null => false
    add_column :users,    :cached_profile_url,  :string,  :default => '',  :null => false
    add_column :users,    :cached_pic_square,   :string,  :default => '',  :null => false
  end

  def self.down
    remove_column :users,    :lat
    remove_column :users,    :lng
    remove_column :users,    :is_my_app_user
    remove_column :users,    :cached_name
    remove_column :users,    :cached_profile_url
    remove_column :users,    :cached_pic_square
  end
end
