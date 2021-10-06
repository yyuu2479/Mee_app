class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  has_many :notifications, dependent: :destroy
end
