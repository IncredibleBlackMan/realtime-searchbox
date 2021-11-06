require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'register user' do
    context 'successful registration' do
      it 'returns user' do
        post '/users', params: user_params

        result = parse response

        expect(result['user']).to_not be_nil
        expect(response.status).to eq 201
      end
    end

    context 'unsuccessful registration' do
      it 'fails when email is invalid' do

        post '/users', params: user_params.merge(email: 'ramon.com')

        result = parse response

        expect(response.status).to eq 422
        expect(result['errors']['email']).to eq ['is invalid']
      end

      it 'fails when email is blank' do

        post '/users', params: user_params.merge(email: '')

        result = parse response

        expect(response.status).to eq 422
        expect(result['errors']['email']).to eq ['can\'t be blank', 'is invalid']
      end

      it 'fails when passwords invalid' do

        post '/users', params: user_params.merge(password: 'AnotherOne', password_confirmation: 'AnotherOne')

        result = parse response

        expect(response.status).to eq 422
        expect(result['errors']['password']).to eq ['is invalid']
      end

      it 'fails when passwords don\'t match do' do

        post '/users', params: user_params.merge(password_confirmation: 'Another1')

        result = parse response

        expect(response.status).to eq 422
        expect(result['errors']['password_confirmation']).to eq ['doesn\'t match Password']
      end

      it 'fails when password is blank' do

        post '/users', params: user_params.merge(password: '', password_confirmation: '')

        result = parse response

        expect(response.status).to eq 422
        expect(result['errors']['password']).to eq ['can\'t be blank', 'can\'t be blank', 'is invalid']
      end
    end
  end

  def user_params
    {
      email: 'james@james.com',
      password: 'Myname1',
      password_confirmation: 'Myname1'
    }
  end

  def parse(response)
    JSON.parse(response.body)
  end
end
