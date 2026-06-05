class Api::V1::ReportsController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:id])
    existing = Report.find_by(reporter: current_user, reportable: post)
    if existing
      return render json: { error: "already reported" }, status: :unprocessable_entity
    end

    report_params = params.require(:report).permit(:reason, :category)
    report = Report.create!(
      reporter: current_user,
      reportable: post,
      reason: report_params[:reason],
      category: report_params[:category],
      status: "pending"
    )

    render json: { data: report }, status: :created
  end
end

