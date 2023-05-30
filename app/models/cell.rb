class Cell < ApplicationRecord
  belongs_to :image_result
  has_one_attached :photo

  def danger?
    @danger = false
    if sexual_activity > 0.6 || sexual_display > 0.6 || erotica > 0.6 || drugs > 0.6 || gore > 0.6
      @danger = true
    end
    @danger
  end
end
