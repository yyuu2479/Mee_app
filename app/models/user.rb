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
  has_many :visitors, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :notificationing_user, through: :visitors, source: :visited

  # notificationモデルとのアソシエーション(通知モデル)(中間テーブル)(通知送られた側の情報取得)
  has_many :visiteds, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  has_many :notificationer_user, through: :visiteds, source: :visitor

  # フォロー作成メゾット
  def follow(user)
    follower.create(followed_id: user.id)
  end

  # フォロー削除メゾット
  def unfollow(user)
    follower.find_by(followed_id: user.id).destroy
  end

  # フォロー確認メゾット
  def following_user?(user)
    following_user.include?(user)
  end

  # 相互フォロー取得メゾット
  def mutual_follow
    following_user & follower_user
  end

  # フォロー通知作成メゾット
  def create_notification_follow(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user.id, id, 'follow'])
    # インスタンス変数tempに値と言えるものがなければレコード作成
    if temp.blank?
      notification = current_user.visitors.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  # 検索メゾット(User)
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(nickname: content).order(created_at: :desc)
    elsif method == 'forward'
      User.where('nickname LIKE ?', content + '%').order(created_at: :desc)
    elsif method == 'backward'
      User.where('nickname LIKE ?', '%' + content).order(created_at: :desc)
    else
      User.where('nickname LIKE ?', '%' + content + '%').order(created_at: :desc)
    end
  end

  # ソートメゾット
  def self.sort_for(sort)
    if sort == 'new'
      User.order(created_at: :desc).where.not(admin: true)
    elsif sort == 'old'
      User.order(created_at: :asc).where.not(admin: true)
    else
      User.order(created_at: :desc).where.not(admin: true)
    end
  end

  # ゲストユーザー作成・探すメゾット
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.first_name = 'ゲスト'
      user.last_name = 'ゲスト'
      user.nickname = 'ゲスト'
      user.password = SecureRandom.urlsafe_base64
      user.introduction = 'ゲストユーザーです'
      user.admin = true
    end
  end
end
