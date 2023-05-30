class ImageResult < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :cells, dependent: :destroy

  def risk_category
    @categories = {
      "Sexual Activity" => nil,
      "Sexual Display" => nil,
      "Erotica" => nil,
      "Drugs" => nil,
      "Gore" => nil
    }

    @categories["Sexual Activity"] = (sexual_activity.to_f * 100) if sexual_activity.to_f >= 0.05
    @categories["Sexual Display"] = (sexual_display.to_f * 100) if sexual_display.to_f >= 0.05
    @categories["Erotica"] = (erotica.to_f * 100) if erotica.to_f >= 0.05
    @categories["Drugs"] = (drugs.to_f * 100) if drugs.to_f >= 0.05
    @categories["Gore"] = (gore.to_f * 100) if gore.to_f >= 0.0

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

    if profanity_type
      @danger << "profanity"
    end
    return { danger: @danger, caution: @caution, safe: @safe}
  end
end
