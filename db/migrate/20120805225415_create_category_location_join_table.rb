class CreateCategoryLocationJoinTable < ActiveRecord::Migration
  def change
    create_table :categories_locations, :id => false do |t|
      t.integer :category_id
      t.integer :location_id
    end
  end
end
