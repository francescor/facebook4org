class CreateVisits < ActiveRecord::Migration
  def self.up
    create_table :visits do |t|
      t.integer :id
      t.integer :user_id
      t.integer :organisation_id
      t.string  :description
      t.date    :when

      t.timestamps
    end
  end

  def self.down
    drop_table :visits
  end
end
