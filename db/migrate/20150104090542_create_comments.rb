class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :comment
      t.integer :device_id
      t.integer :post_id
      t.integer :ups, :default => 0
      t.integer :downs, :default => 0

      t.timestamps
    end

    add_index :comments, :post_id, :name => 'comments_post_id_index'

  end
end
