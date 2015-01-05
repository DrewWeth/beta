class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]


  skip_before_filter  :verify_authenticity_token
  protect_from_forgery with: :null_session

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  def submit
    result = {}
    result[:status] = "failed"
    if params["device_id"] != nil and params["auth_key"] != nil and params["post_id"] and params["why"] and Device.where(:id => params["device_id"], :auth_key => params["auth_key"]).exists?
      result[:status] = "success"

      result[:data] = Report.create(:device_id => params["device_id"], :post_id => params["post_id"], :why => params["why"])

      post = Post.where(:id => params["post_id"]).take
      if post.views > 30 and (Report.where(:post_id => params["post_id"] / post.views).count >= 0.05)
        post.constraint = 1
        post.save
      end
    else
      result[:reason] = "incorrect params"
    end
    render :json => result
  end


  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:device_id, :post_id, :why, :action)
    end
end
