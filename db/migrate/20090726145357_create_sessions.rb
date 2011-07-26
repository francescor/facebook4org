class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at
    # the following is necessary if you use MySql, while is not if you use posgres (Heroku)
    # execute "ALTER TABLE `sessions` CHANGE `data` `data` LONGTEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL"
  end

  def self.down
    drop_table :sessions
  end
end
