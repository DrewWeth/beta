class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :device_id
      t.integer :post_id
      t.string :why
      t.integer :action, :default => 0

      t.timestamps
    end
  end
end
