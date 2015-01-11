class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # CONSTANTS
  $return_size = 20
  $limited_posting_threshold = 1

  # Allows for REST-ful API
  skip_before_filter  :verify_authenticity_token
  protect_from_forgery with: :null_session

  # Push notifications
  require 'parse-ruby-client'
  Parse.init :application_id => "Q5N1wgUAJKrEbspM7Q2PBv32JbTPt5TQpmstic8D", :api_key => "F42ROt0bhDo0GUnsqqO2t5id7Zj37b64fGYYzRZv"

  #     if Geocoder::Calculations.distance_between([params["latitude"], params["longitude"]] , [p.latitude, p.longitude]) < p.radius

  # latitude, longitude, before?, since?
  def nearby
    result = {} # External json object

    if params["latitude"] != nil and params["longitude"] != nil and params["device_id"] != nil
      result[:status] = "success"
      location = "'POINT (" + params["longitude"].to_s + " " + params["latitude"].to_s + ")'"
      if params["before"] != nil # Posts before a certain time
        posts = Post.where("ST_Distance(latlon, "+ location + ") < radius", :constraint != 1).where("created_at < ?", params["before"]).order("created_at DESC").limit($return_size)
      elsif params["since"] != nil # Refreshing (adding to the top)
        posts = Post.where("ST_Distance(latlon, "+ location + ") < radius", :constraint != 1).where("id > ?", params["since"]).limit($return_size).reverse # Reverse because it's added at the same time
        # count = Post.where("ST_Distance(latlon, "+ location + ") < radius", :constraint != 1).where("created_at > ?", params["since"]).count
        # if count > $return_size # Whether to clear and reload table or not
        #   result["more_than_returned"] = true
        # else
        #   result["more_than_returned"] = false
        # end
      else # Just get relavent messages
        posts = Post.where("ST_Distance(latlon, "+ location + ") < radius", :constraint != 1).order("created_at DESC").limit($return_size)
        if posts.count < $limited_posting_threshold # If shitty result then get a bunch of close ones
          result[:no_local_posts] = true
          posts = Post.order("ST_Distance(latlon, "+ location + ")").where(:constraint != 1).last($return_size) # Get 30 nearest one
        end
      end

      data = []
      posts.each do |p|
        obj = {}
        obj[:post] = p
        obj[:poster] = p.device.profile_url
        obj[:has_seen] ||= DevicePost.where(:device_id => params["device_id"], :post_id => p.id).take
        data << obj
      end
      result[:data] = data

    else
      result[:status] = "failed"
    end
    render :json => result
  end


  # Probably need to make a mass-view thing

  # API POSTs
  def viewed
    result = {}
    result["status"] = "failed"
    if params["device_id"] != nil and params["post_id"] != nil and params["auth_key"] != nil
      if Device.where(:id => params["device_id"], :auth_key => params["auth_key"]).exists?
        if not DevicePost.where(:device_id => params["device_id"], :post_id => params["post_id"]).exists?
          device_post = DevicePost.create(:device_id => params["device_id"], :post_id => params["post_id"]) # Make it so it has been viewed
          Post.update_counters params["post_id"], views: 1 # Update distance by 1/4 mile (1 = 1609)
          result = device_post
        else
          result["reason"] = "View already exists"
        end
      else
        result[:reason] = "invaid auth key"
      end
    end
    render :json => result
  end

  def up
    result = {}
    result[:status] = "failed"
    if params["device_id"] != nil and params["post_id"] != nil and params["auth_key"] != nil
      if Device.where(:id => params["device_id"], :auth_key => params["auth_key"]).exists?
        if device_post = DevicePost.where(:device_id => params["device_id"], :post_id => params["post_id"]).take
          if device_post.action_id == 1
            result[:reason] = "already upvoted"
          else
            post = Post.where(:id => params["post_id"]).take
            if device_post.action_id == 0 # then upvote from neutral
            elsif device_post.action_id == 2 # then switch to downvote from upvote
              post.downs -= 1
            end

            post.ups += 1
            post.save

            if post.ups.modulo(5).zero?
              message = "Your post got " + post.ups.to_s + " upvotes!"
              data = { :alert => message }

              push = Parse::Push.new(data)
              push.where = { :objectId => post.device.parse_token }
              push.save

              puts "Pushed to device " + post.device.parse_token
            end

            device_post.action_id = 1
            device_post.save

            result[:status] = "success"
            result[:device_post] = device_post
            result[:post] = post
          end
        else # Super rare. Shouldn't actually happen
          new_record = DevicePost.create(:device_id => params["device_id"], :post_id => params["post_id"], :action_id => 1)
          Post.update_counters params["post_id"], ups: 1, views: 1 # Update distance by 1/4 mile (1 = 1609)

          result[:status] = "success"
          result[:device_post] = new_record
          result[:post] = "updated"
        end
      else
        result[:reason] = "auth key invalid"
      end
    else
      result[:reason] = "params incomplete"
    end
    render :json => result
  end



  def down
    result = {}
    result[:status] = "failed"
    if params["device_id"] != nil and params["post_id"] != nil and params["auth_key"] != nil # Check params exist
      if Device.where(:id => params["device_id"], :auth_key => params["auth_key"]).exists? # Check auth key
        if device_post = DevicePost.where(:device_id => params["device_id"], :post_id => params["post_id"]).take # Get decision
          if device_post.action_id == 2
            result[:reason] = "already downvoted"
          else
            post = Post.where(:id => params["post_id"]).take
            if device_post.action_id == 1 # then switch to upvote from downvote
              post.ups -= 1
            end

            post.downs += 1


            post.save

            device_post.action_id = 2
            device_post.save

            result[:status] = "success"
            result[:device_post] = device_post
            result[:post] = post
          end
        else # Super rare. Shouldn't actually happen
          new_record = DevicePost.create(:device_id => params["device_id"], :post_id => params["post_id"], :action_id => 2)
          Post.update_counters params["post_id"], downs: 1, views: 1 # Update distance by 1/4 mile (1 = 1609)

          result[:status] = "success"
          result[:device_post] = new_record
          result[:post] = "updated"
        end
      else
        result[:reason] = "auth key invalid"
      end
    else
      result[:reason] = "params incomplete"
    end
    render :json => result
  end


  def submit
    if params["device_id"] != nil and params["auth_key"] != nil and Device.where(:id => params["device_id"], :auth_key => params["auth_key"]).take
      if params["latitude"] != nil and params["longitude"] != nil
        @post = Post.new
        @post.content = params["content"]
        @post.latitude = params["latitude"]
        @post.longitude = params["longitude"]
        @post.device_id = params["device_id"]

        @post.post_url = params["post_url"] unless params["post_url"] == nil
        @post.constraint = params["constraint"] unless params["constraint"] == nil
        @post.radius = params["radius"] unless params["radius"] == nil

        if @post.save
          render :json => @post
        else
          render :json => '{"status": "failed","reason": "parameter problem"}'
        end
      else
        render :json => '{"status": "failed","reason": "need latitude and longitude position"}'
      end
    else
      render :json => '{"status": "failed","reason": "invalid device"}'
    end
  end


  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.last(100)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
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
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :latlon, :views, :ups, :downs, :radius, :device_id, :address, :city)
    end
end
