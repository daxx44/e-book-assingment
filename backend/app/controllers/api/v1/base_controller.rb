# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_validation_error
      rescue_from ActionController::ParameterMissing, with: :render_bad_request

      private

      def render_success(data, status: :ok, meta: nil)
        render json: { success: true, data: data, meta: meta }, status: status
      end

      def render_error(code:, message:, details: nil, status: :unprocessable_entity)
        error = { code: code, message: message }
        error[:details] = details if details.present?

        render json: { success: false, error: error }, status: status
      end

      def render_not_found(exception)
        render_error(
          code: "NOT_FOUND",
          message: exception.message.presence || "Resource not found.",
          status: :not_found
        )
      end

      def render_validation_error(exception)
        render_error(
          code: "VALIDATION_FAILED",
          message: "Please correct the errors below.",
          details: format_validation_errors(exception.record),
          status: :unprocessable_entity
        )
      end

      def render_bad_request(exception)
        render_error(
          code: "BAD_REQUEST",
          message: exception.message,
          status: :bad_request
        )
      end

      def format_validation_errors(record)
        record.errors.map do |error|
          {
            field: error.attribute.to_s,
            code: error.type.to_s,
            message: error.full_message
          }
        end
      end
    end
  end
end
