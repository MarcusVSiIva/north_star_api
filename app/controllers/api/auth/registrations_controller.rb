# frozen_string_literal: true

module Api
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      protected

      def render_create_success
        render json: ::UserSerializer.render(@resource, view: :complete)
      end

      def render_create_error
        render json: {
          messages: @resource.errors.full_messages
        }, status: :unprocessable_entity
      end

      def render_update_success
        render json: ::UserSerializer.render(@resource, view: :complete)
      end

      def render_update_error_user_not_found
        render json: {
          messages: [I18n.t('devise_token_auth.registrations.user_not_found')]
        }, status: :not_found
      end

      def render_destroy_success
        render json: ::UserSerializer.render(@resource, view: :complete)
      end

      def render_destroy_error
        render json: {
          messages: [I18n.t('devise_token_auth.registrations.account_to_destroy_not_found')]
        }, status: :not_found
      end

      private

      def validate_post_data(which, message)
        return unless which.empty?

        render json: {
          messages: [message]
        }, status: :unprocessable_entity
      end
    end
  end
end
