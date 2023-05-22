class ImageResult < ApplicationRecord
  belongs_to :user
  has_one_attatched :photo
end
