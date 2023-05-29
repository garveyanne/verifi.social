class Cell < ApplicationRecord
  belongs_to :image_result
  has_one_attached :photo

  def danger?
    @danger = false
    if sexual_activity > 0.4 || sexual_display > 0.4 || erotica > 0.4 || drugs > 0.4 || gore > 0.4
      @danger = true
    end
    @danger
  end
end
