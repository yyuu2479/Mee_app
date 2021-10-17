class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    Like.create(user_id: current_user.id, post_id: @post.id)
    # いいねしたらnotificationsテーブル(通知モデル)に保存
    @post.create_notification_like(current_user)
  end

  def destroy
    @post = Post.find(params[:post_id])
    Like.find_by(user_id: current_user.id, post_id: @post.id).destroy
  end
end
