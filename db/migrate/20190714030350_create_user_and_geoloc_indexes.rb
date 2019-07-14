class CreateUserAndGeolocIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :email
    add_index :geo_locations, :key
    add_index :geo_locations, :ip
  end
end
