class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  skip_before_filter  :verify_authenticity_token
  protect_from_forgery with: :null_session


  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
  end


  def register
    result = {}
    if params["parse_token"] != nil
      if device = Device.create(:auth_key => random_string, :parse_token => params["parse_token"])
        result[:status] = "success"
        result[:data] = device
      else
        result[:status] = "error"
      end
    else
      result[:status] = "missing parse token"
    end
    render :json => result
  end


  ## post
  ## params =  device_id, auth_key, profile_url
  def newprofile
    result = {}
    result[:status] = "failed"
    if params["auth_key"] != nil and params["device_id"] != nil and params["profile_url"] != nil and device = Device.where(:id => params["device_id"], :auth_key => params["auth_key"]).take
      device.profile_url = params["profile_url"]
      if device.save
        result[:status] = "success"
        result[:data] = device
      else
        result[:status] = "save error"
      end
    else
      result[:status] = "device not valid"
    end

    render :json => result
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    def random_string(length=10)
      chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
      password = ''
      length.times { password << chars[rand(chars.size)] }
      password
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:auth_key, :parse_token, :profile_url)
    end
end
