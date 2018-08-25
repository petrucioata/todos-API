module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do

    rescue_from ActiveRecord::RecordInvalid, with: :_422
    rescue_from ExceptionHandler::AuthenticationError, with: :_401
    rescue_from ExceptionHandler::MissingToken, with: :_422
    rescue_from ExceptionHandler::InvalidToken, with: :_422

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    private

    def _401(error)
      json_response({ message: error.message }, :unauthorized)
    end

    def _422(error)
      json_response({ message: error.message }, :unprocessable_entity)
    end
  end
end
