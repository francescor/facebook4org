class CreateIndividualPostPreferredCountries < ActiveRecord::Migration
  def self.up
    create_table :individual_post_preferred_countries do |t|
      t.integer :individual_post_id,        :null => false  #se aggiungi  :null => false non ci possono essere record senza individual_post
      t.integer :country_id,                :null => false  #se aggiungi  :null => false non ci possono essere record senza country_id

      t.timestamps
    end
  end

  def self.down
    drop_table :individual_post_preferred_countries
  end
end
