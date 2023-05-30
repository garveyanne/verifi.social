class Cell < ApplicationRecord
  belongs_to :image_result
  has_one_attached :photo

  def danger?
    @danger = false
    if sexual_activity.to_f > 0.6 || sexual_display.to_f > 0.6 || erotica.to_f > 0.6 || drugs.to_f > 0.6 || gore.to_f > 0.6
      @danger = true
    end
    @danger
  end
end
