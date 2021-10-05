class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :image

  validates :first_name, presence: true, length: { maximum: 15 }
  validates :last_name, presence: true, length: { maximum: 15 }
  validates :nickname, presence: true, length: { maximum: 10 }

  # postモデルとのアソシエーション
  has_many :posts, dependent: :destroy
  # post_commentモデルとのアソシエーション(中間テーブル)
  has_many :post_comments, dependent: :destroy
  # likeモデルとのアソシエーション(中間テーブル)
  has_many :likes, dependent: :destroy

  # relationshipモデルとのアソシエーション(フォローした側の情報取得)(中間テーブル)
  has_many :follower, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :following_user, through: :follower, source: :followed

  # relationshipモデルとのアソシエーション(フォローされた側の情報取得)(中間テーブル)
  has_many :followed, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :follower_user, through: :followed, source: :follower

  # entryモデルとのアソシエーション(中間テーブル)
  has_many :entries, dependent: :destroy
  # messageモデルとのアソシエーション(中間テーブル)
  has_many :messages, dependent: :destroy

  # notificationモデルとのアソシエーション(通知モデル)(中間テーブル)(通知送った側の情報取得)
  has_many :visitor, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :notificationing_user, through: :visitor, source: :visited

  # notificationモデルとのアソシエーション(通知モデル)(中間テーブル)(通知送られた側の情報取得)
  has_many :visited, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  has_many :notificationer_user, through: :visited, source: :visitor

  # フォロー作成メゾット
  def follow(user)
    self.follower.create(followed_id: user.id)
  end
  
  # フォロー削除メゾット
  def unfollow(user)
    self.follower.find_by(followed_id: user.id).destroy
  end

  # フォロー確認メゾット
  def following_user?(user)
    self.following_user.include?(user)
  end

  # 相互フォロー取得メゾット
  def mutual_follow
    following_user & follower_user
  end
end
