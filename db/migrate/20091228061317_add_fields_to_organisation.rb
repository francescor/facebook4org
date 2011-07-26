class AddFieldsToOrganisation < ActiveRecord::Migration
  def self.up
    #add_column    :organisations,    :street,   :string,  :default => '',  :null => false
    add_column    :organisations,    :lat,      :float,   :default => 0.0, :null => false  #TODO Controlla decimali
    add_column    :organisations,    :lng,      :float,   :default => 0.0, :null => false
  end

  def self.down
    #remove_column :organisations,    :street
    remove_column :organisations,    :lat
    remove_column :organisations,    :lng
  end
end
