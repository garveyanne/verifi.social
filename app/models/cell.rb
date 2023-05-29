class Cell < ApplicationRecord
  belongs_to :image_result
  has_one_attached :photo
end
