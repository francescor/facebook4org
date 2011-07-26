class CreateUserSpokenLanguages < ActiveRecord::Migration
  def self.up
    create_table :user_spoken_languages do |t|
      t.integer  :user_id,                :null => false  #se aggiungi  :null => false non ci possono essere record senza user
      t.integer  :language_id,            :null => false  #se aggiungi  :null => false non ci possono essere record senza langua
      t.integer :rank

      t.timestamps
    end
  end

  def self.down
    drop_table :user_spoken_languages
  end
end
