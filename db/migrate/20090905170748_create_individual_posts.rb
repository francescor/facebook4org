class CreateIndividualPosts < ActiveRecord::Migration
  def self.up
    create_table :individual_posts do |t|
      t.integer :user_id
      t.string :title
      t.string :kind
      t.string :when
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :individual_posts
  end
end
