class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def new
  end

  def create
  end

  def destroy
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    flash[:notice] = "更新が完了しました！！"
    redirect_to post_path(@post)
  end
  
  private
  
  def post_params
    params.require(:post).permit(:title, :image, :body)
  end
end
