class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    Like.create(user_id: current_user.id, post_id: @post.id)
    redirect_to posts_path
    
    # いいねしたらnotificationsテーブル(通知モデル)に保存
    @post.create_notification_like(current_user)
  end

  def destroy
    @post = Post.find(params[:post_id])
    Like.find_by(user_id: current_user.id, post_id: @post.id).destroy
    redirect_to posts_path
  end
end
