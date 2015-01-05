class CreateDevicePosts < ActiveRecord::Migration
  def change
    create_table :device_posts do |t|
      t.integer :device_id
      t.integer :post_id
      t.integer :action_id, :default => 0

      t.timestamps
    end

    add_index :device_posts, :device_id, :name => 'device_id_index'
    add_index :device_posts, :post_id, :name => 'post_id_index'
  end
end
