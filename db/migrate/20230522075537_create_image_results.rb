class CreateImageResults < ActiveRecord::Migration[7.0]
  def change
    create_table :image_results do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :nudity

      t.timestamps
    end
  end
end
