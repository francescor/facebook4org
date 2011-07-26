class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    #add_column    :users,    :street,   :string,  :default => '',  :null => false
    add_column    :users,    :birthday_day,    :integer, :default => 0
    add_column    :users,    :birthday_month,  :integer, :default => 0
    add_column    :users,    :view_counter,    :integer, :default => 0
    add_column    :users,    :twitter,         :string, :default => ''
    add_column    :users,    :linkedin,        :string, :default => ''
  end

  def self.down
    #remove_column :users,    :street
    remove_column :users,  :birthday_day
    remove_column :users,  :birthday_month
    remove_column :users,  :view_counter
    remove_column :users,  :twitter
    remove_column :users,  :linkedin
  end
end
