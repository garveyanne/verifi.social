class AddTextColumnsToImageResultsModel < ActiveRecord::Migration[7.0]
  def change
    add_column :image_results, :profanity_type, :string
    add_column :image_results, :profanity_match, :string
    add_column :image_results, :profanity_intensity, :string
  end
end
