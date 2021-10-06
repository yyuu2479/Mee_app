class SearchsController < ApplicationController
  before_action :authenticate_user!
  def index
    @content = params[:content]
    @model = params[:model]
    @method = params[:method]

    if @model == 'user'
      @result_users = User.search_for(@content, @method)
    else
      @result_posts = Post.search_for(@content, @method)
    end
  end
end
