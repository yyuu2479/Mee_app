class Post < ApplicationRecord
  attachment :image
  
  validates :title, presence: true, length: { maximum: 30 } 
  validates :body, presence: true
  
  belongs_to :user
  belongs_to :genre
  
  has_many :post_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy
end
