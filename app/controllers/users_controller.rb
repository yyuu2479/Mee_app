class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    sort = params[:sort]
    @users = User.sort_for(sort).page(params[:page]).per(12)
  end

  def show
    @user = User.find(params[:id])
    @likes = @user.likes.page(params[:page]).per(8)
    # ajaxをする際に使用
    @follow = Relationship.find_by(follower_id: current_user.id, followed_id: @user.id)

    # チャットルーム関連の部分
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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "更新が完了しました!"
      redirect_to user_path(@user)
    else
      flash[:alert] = "更新ができませんでした！"
      render :edit
    end
  end

  def withdrawal
    @user = User.find(params[:user_id])
  end

  def destroy
    user = User.find(params[:id])
    entries = Entry.where(user_id: user.id)
    # 退会ユーザーがチャットルームを作成していた場合、退会と同時にチャットルームを削除
    # entriesに値がある場合のみ、処理を実行
    if entries.present?
      entries.each do |entry|
        entry.room.destroy
      end
    end
    user.destroy
    flash[:notice] = "退会しました！ またのご利用をお待ちしております！！"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :image, :introduction)
  end

  def correct_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      flash[:alert] = "権限がありません！"
      redirect_to users_path
    end
  end
end
