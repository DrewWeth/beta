class DevicePostsController < ApplicationController
  before_action :set_device_post, only: [:show, :edit, :update, :destroy]

  # GET /device_posts
  # GET /device_posts.json
  def index
    @device_posts = DevicePost.all
  end

  # GET /device_posts/1
  # GET /device_posts/1.json
  def show
  end

  # GET /device_posts/new
  def new
    @device_post = DevicePost.new
  end

  # GET /device_posts/1/edit
  def edit
  end

  # POST /device_posts
  # POST /device_posts.json
  def create
    @device_post = DevicePost.new(device_post_params)

    respond_to do |format|
      if @device_post.save
        format.html { redirect_to @device_post, notice: 'Device post was successfully created.' }
        format.json { render :show, status: :created, location: @device_post }
      else
        format.html { render :new }
        format.json { render json: @device_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /device_posts/1
  # PATCH/PUT /device_posts/1.json
  def update
    respond_to do |format|
      if @device_post.update(device_post_params)
        format.html { redirect_to @device_post, notice: 'Device post was successfully updated.' }
        format.json { render :show, status: :ok, location: @device_post }
      else
        format.html { render :edit }
        format.json { render json: @device_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /device_posts/1
  # DELETE /device_posts/1.json
  def destroy
    @device_post.destroy
    respond_to do |format|
      format.html { redirect_to device_posts_url, notice: 'Device post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device_post
      @device_post = DevicePost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_post_params
      params.require(:device_post).permit(:device_id, :post_id, :action_id)
    end
end
