class ImageResult < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :cells, dependent: :destroy
end
