class Message < ApplicationRecord
  validates :body, presence: true, length:{maximum: 50}
  
  belongs_to :user
  belongs_to :room
end
