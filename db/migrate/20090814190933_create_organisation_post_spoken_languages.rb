class CreateOrganisationPostSpokenLanguages < ActiveRecord::Migration
  def self.up
    create_table :organisation_post_spoken_languages do |t|
      t.integer :organisation_post_id,    :null => false  #se aggiungi  :null => false non ci possono essere record senza organisation_post
      t.integer  :language_id,            :null => false  #se aggiungi  :null => false non ci possono essere record senza langua
      t.integer :rank

      t.timestamps
    end
  end

  def self.down
    drop_table :organisation_post_spoken_languages
  end
end
