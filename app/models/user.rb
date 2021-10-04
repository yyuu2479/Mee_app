class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :image

  validates :first_name, presence: true, length: { maximum: 15 }
  validates :last_name, presence: true, length: { maximum: 15 }
  validates :nickname, presence: true, length: { maximum: 10 }

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :follower, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :following_user, through: :follower, source: :followed

  has_many :followed, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :follower_user, through: :followed, foreign_key: :follower

  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :visitor, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :notificationing_user, through: :visitor, source: :visited

  has_many :visited, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  has_many :notificationer_user, through: :visited, source: :visitor
end
