class DefaultAndIndexes < ActiveRecord::Migration
  def change
    add_index :posts, :created_at, :name => 'post_created_at_index'
    add_index :posts, :device_id, :name => 'post_device_foreign_key_index'
  end
end
