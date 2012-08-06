class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.string :name
      t.string :category
      t.string :fb_id

      t.timestamps
    end
  end
end
