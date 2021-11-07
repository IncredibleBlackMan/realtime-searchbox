require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe 'sign_in user' do
    context 'successful sign_in' do
      it 'returns user' do
        post '/login', params: { user: { email: user.email, password: user.password } }

        expect(response).to redirect_to('/articles')
      end
    end

    context 'unsuccessful sign_in' do
      it 'returns err when wrong password is supplied' do
        post '/login', params: { user: { email: user.email, password: 'WrongPass' } }


        expect(response).to redirect_to('/login')
      end
    end
  end

  def parse(response)
    JSON.parse(response.body)
  end
end
