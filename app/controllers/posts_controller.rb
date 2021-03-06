class PostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'アイデアを投稿しました。'
      redirect_to root_url
    else
      @posts = current_user.feed_posts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'アイデアの投稿に失敗しました。'
      render 'toppages/index'
    end  
  end
  
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    #@comment = @post.comments.build
   
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
    flash[:success] = 'アイデアが編集されました'
    redirect_to @post
    else
    flash.now[:danger] = 'アイデアが編集されませんでした'
    render :new
    end
  end
  

  def destroy
    @post.destroy
    flash[:success] = 'アイデアを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
  
  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to root_url
    end
  end
end
