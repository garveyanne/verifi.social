class AddIndexToCells < ActiveRecord::Migration[7.0]
  def change
    add_index :cells, [:image_result_id, :col, :row], unique: true
  end
end
