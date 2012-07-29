class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :longitude
      t.string :latitude
      t.string :radius

      t.timestamps
    end
  end
end
