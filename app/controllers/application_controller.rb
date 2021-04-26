class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordInvalid, with: lambda { |e| handle_validation_error(e) }

  def handle_validation_error(error)
    error_model = error.try(:model) || error.try(:record)
    errors = error_model.errors.reduce([]) do |r, e|
      r << {
        source: { pointer: "/data/attributes/#{e.attribute}" },
        detail: e.message,
        status: 422,
        title: "Invalid request"
      }
    end
    render json: { errors: errors }, status: 422
  end
end
