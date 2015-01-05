class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.integer :device_id
      t.integer :user_id
      t.text :message

      t.timestamps
    end
  end
end
