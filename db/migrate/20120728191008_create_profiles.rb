class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.integer :characteristic_id
      t.float :likelihood

      t.timestamps
    end
  end
end
