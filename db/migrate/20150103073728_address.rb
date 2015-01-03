class Address < ActiveRecord::Migration
  def change
    add_column :posts, :address, :string
  end
end
