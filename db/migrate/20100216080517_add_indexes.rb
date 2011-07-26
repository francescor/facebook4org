class AddIndexes < ActiveRecord::Migration
  def self.up
    # Vedi Mangino p. 71
    add_index :users, :uid
    add_index :users, :signup_step
    add_index :users, [:organisation_id, :created_at]
    add_index :contacts, [:user_id, :created_at]
    add_index :contacts, [:contacted_user_id, :created_at]
    add_index :visits, [:user_id, :created_at]
    add_index :visits, [:organisation_id, :created_at]
  end

  def self.down
    remove_index :users, :uid
    remove_index :users, :signup_step
    remove_index :users, [:organisation_id, :created_at]
    remove_index :contacts, [:user_id, :created_at]
    remove_index :contacts, [:contacted_user_id, :created_at]
    remove_index :visits, [:user_id, :created_at]
    remove_index :visits, [:organisation_id, :created_at]
  end
end
