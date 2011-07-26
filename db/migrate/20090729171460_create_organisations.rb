class CreateOrganisations < ActiveRecord::Migration
  def self.up
    create_table :organisations do |t|
      t.string :name
      t.string :short_name
      t.string :homepage
      t.string    :city
      t.string    :street
      t.string    :state
      t.string    :post_code
      t.string    :country  
      t.timestamps
    end
  end

  def self.down
    drop_table :organisations
  end
end
