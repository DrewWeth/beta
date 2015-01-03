class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content, :default => ""
      t.point :latlon, :geographic => true
      t.integer :views, :default => 0
      t.integer :ups, :default => 0
      t.integer :downs, :default => 0
      t.float :radius, :default => 2
      t.integer :device_id

      t.timestamps
    end
  end
end
