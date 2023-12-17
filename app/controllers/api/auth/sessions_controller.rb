# frozen_string_literal: true

module Api
  module Auth
    class SessionsController < DeviseTokenAuth::SessionsController
      protected

      def render_create_success
        render json: ::UserSerializer.render(@resource, view: :complete)
      end

      def render_create_error_bad_credentials
        render json: {
          messages: [I18n.t('devise_token_auth.sessions.bad_credentials')]
        }, status: :unauthorized
      end
    end
  end
end
