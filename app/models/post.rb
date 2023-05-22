class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  act_as_taggable_on :tags

  has_one_attatched :photo

  validates :title, presence: true
end
