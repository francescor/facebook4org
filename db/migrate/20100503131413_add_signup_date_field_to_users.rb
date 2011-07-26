class AddSignupDateFieldToUsers < ActiveRecord::Migration
  def self.up
    add_column    :users,    :last_signup_step_at,    :datetime
  end

  def self.down
    remove_column :users,    :last_signup_step_at
  end
end
