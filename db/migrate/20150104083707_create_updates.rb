class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.string :message
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
