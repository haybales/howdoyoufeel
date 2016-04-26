class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    if cookies[:voted] == nil
      cookies[:voted]=""
    end
    @posts = Post.all.order("id").reverse
    if(params[:sort])
      @posts = Post.order(params[:sort]).reverse
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    if cookies[:secret] == "spinach"
      @post = Post.new
    else
      redirect_to(root_path)
    end
  end

  # GET /posts/1/edit
  def edit
    if cookies[:secret] == "spinach"
    else
      redirect_to(root_path)
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(toast_params)
    if(Post.count > 50)
      Post.first.destroy
    end
    respond_to do |format|
      if verify_recaptcha() && @post.save
        format.html { redirect_to root_path, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { redirect_to root_path, notice: 'you goofed!' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to root_path, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    
    if cookies[:voted] == nil
      cookies[:voted]=""
    end
    
    @post = Post.find(params[:id])
    if !cookies[:voted].include?("a"+@post.id.to_s)
      @post.vote = @post.vote + 1
      @post.save
      cookies[:voted]=cookies[:voted]+"a"+@post.id.to_s;
    end
    respond_to do |format|
      format.js
    end
  end

  def downvote
    
    if cookies[:voted] == nil
      cookies[:voted]=""
    end
    
    @post = Post.find(params[:id])
    if cookies[:voted].include?("a"+@post.id.to_s)
      @post.vote = @post.vote - 1
      @post.save
      cookies[:voted]=cookies[:voted].gsub("a"+@post.id.to_s, "")
    end
    respond_to do |format|
      format.js
    end
  end

  def givemod
    if params[:q]=="boob"
      cookies[:secret] = "spinach"
      redirect_to(root_path, notice: 'You now have Mod powers.')
      return false
    end
    redirect_to(root_path)
  end

  def removemod
    cookies.delete :secret
    redirect_to(root_path, notice: 'Mod powers removed.')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:body, :vote)
    end
    def toast_params
      params.permit(:body)
    end
end
