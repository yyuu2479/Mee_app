class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_follow, only:[:create, :destroy]
  
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
    current_user.follow(@user)
    
    # フォローしたらnotificationsテーブル(通知モデル)に保存
    @user.create_notification_follow(current_user)
    redirect_to user_path(@user)
  end
  
  def destroy
    @user = User.find(params[:user_id])
    # フォロー削除メゾット(unfollow(@user))
    current_user.unfollow(@user)
    redirect_to user_path(@user)
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
