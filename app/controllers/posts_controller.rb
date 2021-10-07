class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_post, only:[:edit, :update, :destroy]

  def index
    sort = params[:sort]
    @posts = Post.sort_for(sort)
  end

  def show
    @post = Post.find(params[:id])
    @post_comments = PostComment.where(post_id: @post.id).order(created_at: :desc)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_create_params)
    if @post.save
      flash[:notice] = "投稿が完了しました！！"
      redirect_to posts_path
    else
      render :new
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    flash[:notice] = "投稿を削除しました！！"
    redirect_to posts_path
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_update_params)
      flash[:notice] = "更新が完了しました！！"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  private

  def post_create_params
    params.require(:post).permit(:title, :image, :user_id, :genre_id, :body).merge(user_id: current_user.id)
  end

  def post_update_params
    params.require(:post).permit(:title, :image, :body)
  end

  def correct_post
    post = Post.find(params[:id])
    redirect_to posts_path unless post.user.id == current_user.id
  end
end
