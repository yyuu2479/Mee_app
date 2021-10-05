class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    Like.create(user_id: current_user.id, post_id: @post.id)
    redirect_to posts_path
  end

  def destroy
    @post = Post.find(params[:post_id])
    Like.find_by(user_id: current_user.id, post_id: @post.id).destroy
    redirect_to posts_path
  end
end
