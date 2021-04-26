class ApplicationController < ActionController::Base
  include JsonapiErrorsHandler
  skip_before_action :verify_authenticity_token

  ErrorMapper.map_errors!({
    'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound',
  })

  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
  rescue_from ActiveRecord::RecordInvalid, with: lambda { |e| handle_validation_error(e) }

  private

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
