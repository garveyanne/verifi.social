class AddColumnsToImageResultTable < ActiveRecord::Migration[7.0]
  def change
    add_column :image_results, :sexual_activity, :float
    add_column :image_results, :sexual_display, :float
    add_column :image_results, :erotica, :float
    add_column :image_results, :suggestive, :float
    add_column :image_results, :drugs, :float
    add_column :image_results, :nazi, :float
    add_column :image_results, :confederate, :float
    add_column :image_results, :supremacist, :float
    add_column :image_results, :terrorist, :float
    add_column :image_results, :gore, :float
  end
end
