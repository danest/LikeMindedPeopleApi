class CreateCharacteristics < ActiveRecord::Migration
  def change
    create_table :characteristics do |t|
      t.string :key
      t.string :attributeCategories

      t.timestamps
    end
  end
end
