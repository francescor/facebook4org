class AddFieldsToOrganisation2 < ActiveRecord::Migration
  def self.up
    #add_column    :organisations,    :street,   :string,  :default => '',  :null => false
    add_column    :organisations,    :teh_membership,   :string,  :default => '',  :null => false
    add_column    :organisations,    :teh_link,         :string
    add_column    :organisations,    :view_counter,     :integer, :default => 0
  end

  def self.down
    #remove_column :organisations,    :street
    remove_column :organisations,  :teh_membership
    remove_column :organisations,  :teh_link
    remove_column :organisations,  :view_counter
  end
end
