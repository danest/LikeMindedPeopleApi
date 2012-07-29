class CreateInterestPoints < ActiveRecord::Migration
  def change
    create_table :interest_points do |t|
      t.integer :user_id
      t.integer :location_id
      t.integer :rank

      t.timestamps
    end
  end
end
