require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe 'sign_in user' do
    context 'successful sign_in' do
      it 'returns user' do
        post '/sessions', params: { user: { email: user.email, password: user.password } }

        result = parse response

        expect(result['user']).to_not be_nil
        expect(response.status).to eq 200
      end
    end

    context 'unsuccessful sign_in' do
      it 'returns err when wrong password is supplied' do
        post '/sessions', params: { user: { email: user.email, password: 'WrongPass' } }

        result = parse response

        expect(response.status).to eq 401
        expect(result['errors']).to eq 'Invalid email / password'
      end
    end
  end

  def parse(response)
    JSON.parse(response.body)
  end
end
