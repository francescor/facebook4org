class CreateOrganisationPosts < ActiveRecord::Migration
  def self.up
    create_table :organisation_posts do |t|
      t.integer  :organisation_id,    :null => false  #se aggiungi  :null => false non ci possono essere record senza organisation
      t.integer  :user_id,            :null => false  #se aggiungi  :null => false non ci possono essere record senza user
      t.string   :category
      t.string   :area
      t.integer  :duration
      t.date     :when #we need this to sort organisation posts, ordering the by date
      #t.string   :what
      #t.string   :who
      t.text     :short_description
      t.text     :description

      t.timestamps
    end
  end

  def self.down
    drop_table :organisation_posts
  end
end
