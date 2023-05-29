class CreateCells < ActiveRecord::Migration[7.0]
  def change
    create_table :cells do |t|
      t.references :image_result, null: false, foreign_key: true
      t.float :sexual_activity
      t.float :sexual_display
      t.float :erotica
      t.float :drugs
      t.float :gore
      t.integer :x_coor
      t.integer :y_coor
      t.integer :row
      t.integer :col
      t.string :photo_url
      t.string "profanity_type"
      t.string "profanity_match"
      t.string "profanity_intensity"

      t.timestamps
    end
  end
end
