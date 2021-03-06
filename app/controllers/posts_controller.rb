class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_post, only: [:edit, :update, :destroy]

  def index
    sort = params[:sort]
    genre = params[:genre]
    # ソートする内容によって処理を分岐させてます
    if sort == 'new' && genre.present?
      @posts = Kaminari.paginate_array(Post.sort_new_genre(sort, genre)).page(params[:page]).per(20)
    elsif sort == 'old' && genre.present?
      @posts = Kaminari.paginate_array(Post.sort_old_genre(sort, genre)).page(params[:page]).per(20)
    elsif sort.present? && genre.blank?
      @posts = Kaminari.paginate_array(Post.sort_for(sort)).page(params[:page]).per(20)
    else
      @posts = Kaminari.paginate_array(Post.all.reverse_order).page(params[:page]).per(20)
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comments = PostComment.where(post_id: @post.id).order(created_at: :desc).page(params[:page]).per(12)
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
      flash[:alert] = "投稿ができませんでした！"
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
      flash[:alert] = "更新できませんでした！"
      render :edit
    end
  end

  private

  def post_create_params
    params.require(:post).permit(:title, :image, :user_id, :genre_id, :body).merge(user_id: current_user.id)
  end

  def post_update_params
    params.require(:post).permit(:title, :image, :genre_id, :body)
  end

  def correct_post
    post = Post.find(params[:id])
    unless post.user.id == current_user.id
      flash[:alert] = "あなたの編集ページではありません！"
      redirect_to posts_path
    end
  end
end
