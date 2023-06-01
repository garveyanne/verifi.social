class ImageResult < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :cells, dependent: :destroy

  def risk_category
    # method to display on the index page if something is at risk or not
    # declare cats
    @categories = {
      "Sexual Activity" => sexual_activity.to_f,
      "Sexual Display" => sexual_display.to_f,
      "Erotica" => erotica.to_f,
      "Drugs" => drugs.to_f,
      "Gore" => gore.to_f
    }
    # assign empty array to hold danger items
    @danger = []
    # test if the items as at risk
    @categories.each do |name, value|
      @danger << name if value > 0.6
    end
    # test if profanity exists
    if profanity_type
      @danger << "profanity"
    end

    if cells.any? { |cell| cell.danger? }
      @danger << "grid"
    end
    return { danger: @danger, caution: @caution, safe: @safe}
  end
end
