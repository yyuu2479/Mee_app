class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_follow, only: [:create, :destroy]

  def following
    @user = User.find(params[:user_id])
    # フォローされた人を取得
    @followings = @user.following_user.page(params[:page]).per(8)
  end

  def follower
    @user = User.find(params[:user_id])
    # フォローした人を取得
    @followers = @user.follower_user.page(params[:page]).per(8)
  end

  def mutual_follow
    @user = User.find(params[:user_id])
    # 相互フォローした人を取得
    @mutual_follows = Kaminari.paginate_array(@user.mutual_follow).page(params[:page]).per(8)
  end

  def create
    @user = User.find(params[:user_id])
    # フォロー作成メゾット(follow(@user))
    @follow = current_user.follow(@user)
    # フォローしたらnotificationsテーブル(通知モデル)に保存
    @user.create_notification_follow(current_user)

    @current_user_entry = Entry.where(user_id: current_user.id)
    @user_entry = Entry.where(user_id: @user.id)
    unless current_user.id == @user.id
      @current_user_entry.each do |current|
        @user_entry.each do |user|
          if current.room_id == user.room_id
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    # フォロー削除メゾット(unfollow(@user))
    current_user.unfollow(@user)
  end

  private

  # 直打ち禁止メゾット
  def correct_follow
    @user = User.find(params[:user_id])
    unless current_user.id != @user.id
      redirect_to user_path(current_user.id)
    end
  end
end
