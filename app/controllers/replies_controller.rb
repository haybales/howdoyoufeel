class RepliesController < ApplicationController
  before_action :set_reply, only: [:show, :edit, :update, :destroy]

  # GET /replies
  # GET /replies.json
  def index
    if cookies[:secret] == "spinach"
      @replies = Reply.all
    else 
      redirect_to(root_path)
    end
  end

  # GET /replies/1
  # GET /replies/1.json
  def show
    if cookies[:secret] == "spinach"
    else
      redirect_to(root_path)
    end
  end

  # GET /replies/new
  def new
    @reply = Reply.new
  end

  # GET /replies/1/edit
  def edit
    if cookies[:secret] == "spinach"
    else
      redirect_to(root_path)
    end
  end

  # POST /replies
  # POST /replies.json
  def create
    @reply = Reply.new(reply_params)
    respond_to do |format|
      if verify_recaptcha() && @reply.save
        format.html { redirect_to post_path(Post.find(reply_params[:post_id])), notice: 'Reply was successfully created.' }
        format.json { render :show, status: :created, location: @reply }
      else
        format.html { redirect_to post_path(Post.find(reply_params[:post_id])), notice: 'you goofed!' }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /replies/1
  # PATCH/PUT /replies/1.json
  def update
    respond_to do |format|
      if @reply.update(reply_params)
        format.html { redirect_to root_path, notice: 'Reply was successfully updated.' }
        format.json { render :show, status: :ok, location: @reply }
      else
        format.html { render :edit }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /replies/1
  # DELETE /replies/1.json
  def destroy
    @reply.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Reply was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reply
      @reply = Reply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reply_params
      params.permit(:body, :post_id)
    end
end
