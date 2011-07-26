class CreateAccommodations < ActiveRecord::Migration
  def self.up
    create_table :accommodations do |t|
      t.integer :user_id
      t.integer :organisation_id
      t.string :type
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :post_code
      t.float :latitude
      t.float :longitude
      t.string :status
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :accommodations
  end
end
