class CreateGeoLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :geo_locations do |t|
      t.string :key
      t.string :ip
      t.string :country_code
      t.string :city
      t.string :zip
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
