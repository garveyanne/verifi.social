class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :post
  attribute :unread, :boolean, default: true
end
