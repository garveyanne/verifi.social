class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  acts_as_taggable_on :tags

  has_one_attached :photo

  validates :title, presence: true
end
