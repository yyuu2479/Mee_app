class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only:[:edit, :update]

  def index
    sort = params[:sort]
    @users = User.sort_for(sort)
  end

  def show
    @user = User.find(params[:id])
    @likes = @user.likes
    
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
    @user.update(user_params)
    flash[:notice] = "更新が完了しました"
    redirect_to user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :image)
  end
  
  def correct_user
    user = User.find(params[:id])
    redirect_to users_path unless user.id == current_user.id
  end

end
