# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth::Registrations', type: :request do
  describe 'POST /auth' do
    context 'when try to register with valid data' do
      it 'returns the user data with auth headers' do
        params = {
            email: 'teste@gmail.com',
            password: '12345678'
        }

        post('/api/auth', params:)

        expect(response).to have_http_status(:success)
        expect(response.parsed_body.deep_symbolize_keys).to(match(
            {
                email: 'teste@gmail.com',
                id: 1
            }
        ))
      end
    end

    context 'when registering a new user without password' do
      it 'returns unprocessable entity' do
        params = {
              email: 'teste@gmail.com'
          }

        post('/api/auth', params:)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body.deep_symbolize_keys).to(match(
            {
                messages: ["Password can't be blank"]
            }
        ))
      end
    end

    context 'when registering a new user without email' do
      it 'returns unprocessable entity' do
        params = {
              password: '12345678'
          }

        post('/api/auth', params:)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body.deep_symbolize_keys).to(match(
            {
                messages: ["Email can't be blank"]
            }
        ))
      end
    end

    context 'when registering a new user with invalid email' do
      it 'returns unprocessable entity' do
        params = {
              email: 'teste',
              password: '12345678'
          }

        post('/api/auth', params:)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body.deep_symbolize_keys).to(match(
            {
                messages: ['Email is not an email']
            }
        ))
      end
    end

    context 'when registering a new user with email already registered' do
      it 'returns unprocessable entity' do
        create(:user, email: 'teste@gmail.com')

        params = {
            email: 'teste@gmail.com',
            password: '12345678'
        }

        post('/api/auth', params:)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body.deep_symbolize_keys).to(match(
            {
                messages: ['Email has already been taken']
            }
        ))
      end
    end
  end

  describe 'PUT /auth' do
    context 'when try to update user that exists with valid data' do
      it 'returns the user data with auth headers' do
        user = create(:user)

        params = {
            email: 'new_email@gmail.com'
        }

        put '/api/auth/', params:, headers: user.create_new_auth_token

        expect(response).to have_http_status(:success)
        expect(response.parsed_body.deep_symbolize_keys).to(match(
            {
                email: 'new_email@gmail.com',
                id: user.id
            }
        ))
      end
    end

    context 'when try to update user that does not exists' do
      it 'returns not found' do
        params = {
              email: 'teste@teste.com'
          }

        put('/api/auth/', params:)

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body.deep_symbolize_keys).to(match(
            {
                messages: ['User not found.']
            }
        ))
      end
    end
  end

  describe 'DELETE /auth' do
    context 'when try to delete user that exists' do
      it 'returns the user data with auth headers' do
        user = create(:user)

        delete '/api/auth/', headers: user.create_new_auth_token

        expect(response).to have_http_status(:success)
        expect(response.parsed_body.deep_symbolize_keys).to(match(
            {
                email: user.email,
                id: user.id
            }
        ))
      end
    end

    context 'when try to delete user that does not exists' do
      it 'returns not found' do
        delete '/api/auth/'

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body.deep_symbolize_keys).to(match(
            {
                messages: ['Unable to locate account for destruction.']
            }
        ))
      end
    end
  end
end
