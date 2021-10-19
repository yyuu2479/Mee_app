class PostComment < ApplicationRecord
  validates :comment, presence: true, length: { maximum: 120 }

  belongs_to :user
  belongs_to :post

  has_many :notifications, dependent: :destroy
end
