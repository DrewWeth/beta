class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :auth_key
      t.string :parse_token
      t.string :profile_url

      t.timestamps
    end
  end
end
