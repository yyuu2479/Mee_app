class Post < ApplicationRecord
  attachment :image
  
  belongs_to :user
  belongs_to :genre
  
  has_many :post_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy
end
