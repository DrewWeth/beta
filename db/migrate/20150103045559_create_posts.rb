class CreatePosts < ActiveRecord::Migration
  def change
    execute "CREATE EXTENSION IF NOT EXISTS postgis;"

    create_table :posts do |t|
      t.string :content, :default => ""
      t.point :latlon, :geographic => true
      t.integer :views, :default => 0
      t.integer :ups, :default => 0
      t.integer :downs, :default => 0
      t.float :radius, :default => 3219 # 2 Miles in meters
      t.integer :device_id # FK for owner
      t.string :post_url
      t.integer :constraint, :default => 0 # 0 = no constraints, 1 = reported and banned, 2 for advert

      t.timestamps
    end

    
  end

end
