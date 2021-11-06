class SearchsController < ApplicationController
  before_action :authenticate_user!
  def index
    @content = params[:content]
    @model = params[:model]
    @method = params[:method]

    if @model == 'user'
      @results = User.search_for(@content, @method).page(params[:page]).per(9)
    else
      @results = Post.search_for(@content, @method).page(params[:page]).per(9)
    end
  end
end
