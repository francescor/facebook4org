class AddFieldsToOrganisation3 < ActiveRecord::Migration
  def self.up
    #add_column    :organisations,    :street,   :string,  :default => '',  :null => false
    add_column    :organisations,    :facebook_link,    :string
  end

  def self.down
    #remove_column :organisations,    :street
    remove_column :organisations,  :facebook_link
  end
end
