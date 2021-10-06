class PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_post_comment, only:[:edit, :destroy, :update]

  def new
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.find(params[:id])
  end

  def create
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new(post_comment_params)
    if @post_comment.save
      flash[:notice] = "投稿が完了しました！！"
      
      # コメントしたらnotificationsテーブル(通知モデル)に保存
      @notification_post = @post_comment.post
      @notification_post.create_notification_comment(current_user, @post_comment.id)
      
      redirect_to post_path(@post)
    else
      @post_comment = PostComment.new
      render :new
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.find(params[:id])
    PostComment.find_by(post_id: @post.id, id: @post_comment.id).destroy
    flash[:notice] = "投稿を削除しました！！"
    redirect_to post_path(@post)
  end

  def update
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.find(params[:id])
    if @post_comment.update(post_comment_params)
      flash[:notice] = "更新が完了しました！！"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:user_id, :post_id, :comment).merge(user_id: current_user.id, post_id: @post.id)
  end

  def correct_post_comment
    post_comment = PostComment.find(params[:id])
    redirect_to posts_path unless post_comment.user.id == current_user.id
  end
end
