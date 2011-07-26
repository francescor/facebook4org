class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :id
      t.integer :user_id
      t.integer :contacted_user_id
      t.string  :description
      t.date    :when

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
