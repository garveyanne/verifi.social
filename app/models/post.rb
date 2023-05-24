class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  acts_as_taggable_on :tags

  has_one_attached :photo

  validates :title, presence: true

  include PgSearch::Model
pg_search_scope :search_by_title_and_content,
  against: [ :title, :content],
  using: {
    tsearch: { prefix: true } # <-- now `superman batm` will return something!
  }
end
