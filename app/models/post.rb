class Post < ApplicationRecord
  attachment :image

  validates :title, presence: true, length: { maximum: 30 }
  validates :body, presence: true

  belongs_to :user
  belongs_to :genre

  has_many :post_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy
  # 現在ログインしているユーザーがこの投稿にいいねしているか判定メゾット
  def liked_by?(user)
    self.likes.where(user_id: user.id).exists?
  end

  # いいね通知作成メゾット
  def create_notification_like(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ?", current_user.id, user_id, id, 'like'])
    # インスタンス変数tempに値と言えるものが存在していなければレコード作成
    if temp.blank?
      notification = current_user.visitors.new(
        visited_id: user_id,
        post_id: id,
        post_comment_id: 0,
        action: 'like'
      )
      # 通知を送ったユーザーと通知を送られてユーザーのIDが等しいときは通知を送らない
      notification.checked = true if notification.visitor_id == notification.visited_id

      notification.save if notification.valid?
    end
  end

  # コメント通知メゾット
  def create_notification_comment(current_user, post_comment_id)
    temps = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct

    temps.each do |temp|
      save_notification_comment(current_user, temp[:user_id], post_comment_id)
    end

    save_notification_comment(current_user, user_id, post_comment_id) if temps.blank?
  end

  def save_notification_comment(current_user, visited_id, post_comment_id)
    # visitors(userモデルとnotificationモデルのアソシエーション名)
    notification = current_user.visitors.new(
      visited_id: visited_id,
      post_id: id,
      post_comment_id: post_comment_id,
      action: 'post_comment'
      )
    # 通知を送ったユーザーと通知を送られてユーザーのIDが等しいときは通知を送らない
    notification.checked = true if notification.visitor_id == notification.visited_id

    notification.save if notification.valid?
  end
  # 検索メゾット（Post)
  def self.search_for(content, method)
    if method == 'perfect'
      Post.where(title: content).order(created_at: :desc)
    elsif method == 'forward'
      Post.where('title LIKE ?', content + '%').order(created_at: :desc)
    elsif method == 'backward'
      Post.where('title LIKE ?', '%' + content).order(created_at: :desc)
    else
      Post.where('title LIKE ?', '%' + content + '%').order(created_at: :desc)
    end
  end
  # ソートメゾット
  def self.sort_for(sort)
    if sort == 'new'
      Post.order(created_at: :desc)
    elsif sort == 'old'
      Post.order(created_at: :asc)
    else
      Post.order(created_at: :desc)
    end
  end
end
