# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth::Sessions', type: :request do
  describe 'POST /auth/sign_in' do
    context 'when try to login with valid data' do
      it 'returns the user data with auth headers' do
        user = create(:user)

        post '/api/auth/sign_in', params: {
          email: user.email,
          password: user.password
        }

        expect(response).to have_http_status(:success)
        expect(response.parsed_body.deep_symbolize_keys).to(match(
            {
                email: user.email,
                id: 1
            }
        ))
      end
    end

    context 'when try to login with invalid data' do
      it 'returns unauthorized' do
        post '/api/auth/sign_in', params: {
          email: 'teste@gmail.com',
          password: '12345678'
        }

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body.deep_symbolize_keys).to(match(
            {
                messages: ['Invalid login credentials. Please try again.']
            }
        ))
      end
    end
  end
end
