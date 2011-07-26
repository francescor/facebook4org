class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table  :users do |t|
      t.integer   :organisation_id
      t.integer   :uid, :limit => 8, :null => false
      t.integer   :signup_step,     :default => 0
      t.boolean   :is_admin,        :default => false, :null => false
      t.string    :session_key
      t.string    :session_expires
      t.string    :gender
      t.integer   :age
      t.string    :city
      t.string    :street,          :default => '',  :null => false
      t.string    :state
      t.string    :post_code
      t.string    :country
      #t.float     :lat,          :default => 0.0,  :null => false  #TODO Controlla decimali
      #t.float     :lng,          :default => 0.0,  :null => false
      t.string    :job_area
      t.string    :job_role
      t.text      :job_description
      t.integer   :go_as_worker  
      t.integer   :go_as_volunteer
      t.integer   :go_as_intern
      t.integer   :go_as_visitor
      t.text      :go_info
      t.string    :hosting
      t.string    :infopoint
      t.datetime  :last_access, :default => nil

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
