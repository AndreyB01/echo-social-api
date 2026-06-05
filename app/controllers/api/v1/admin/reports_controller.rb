module Api
  module V1
    module Admin
      class ReportsController < BaseController
        def index
          render json: Report.all
        end

        def update
          report = Report.find(params[:id])

          report.update!(
            status: "resolved"
          )

          render json: report
        end
      end
    end
  end
end

