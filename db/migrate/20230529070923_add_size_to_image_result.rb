class AddSizeToImageResult < ActiveRecord::Migration[7.0]
  def change
    add_column :image_results, :width, :integer
    add_column :image_results, :height, :integer
  end
end
