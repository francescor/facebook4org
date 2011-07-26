class AddFieldsToOrganisations4 < ActiveRecord::Migration
  def self.up
    #add_column    :organisations,    :street,   :string,  :default => '',  :null => false
    add_column    :organisations,    :image_link,    :string
  end

  def self.down
    #remove_column :organisations,    :street
    remove_column :organisations,  :image_link
  end
end
