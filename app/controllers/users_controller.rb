class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only:[:edit, :update]

  def index
    @users = User.order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
    @likes = @user.likes.all
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
