class ImageResult < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :cells, dependent: :destroy

def risk_category
    @categories = {
      "Sexual Activity" => nil,
      "Sexual Display" => nil,
      "Erotica" => nil,
      "Suggestive" => nil,
      "Drugs" => nil,
      "Gore" => nil
    }

    @categories["Sexual Activity"] = (sexual_activity * 100) if sexual_activity >= 0.05
    @categories["Sexual Display"] = (sexual_display * 100) if sexual_display >= 0.05
    @categories["Erotica"] = (erotica * 100) if erotica >= 0.05
    @categories["Suggestive"] = (suggestive * 100) if suggestive >= 0.05
    @categories["Drugs"] = (drugs * 100) if drugs >= 0.05
    @categories["Gore"] = (gore * 100) if gore >= 0.0

    @danger = []
    @caution = []
    @safe = []
    @categories.each do |name, value|
      if value.to_i > 40
        @danger << name
      elsif value.to_i > 20
        @caution << name
      else
        @safe << name
      end
    end

    return { danger: @danger, caution: @caution, safe: @safe}
  end
end
