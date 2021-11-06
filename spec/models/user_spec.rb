require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :password }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password_confirmation }
  it { should have_secure_password }

  let(:user) { create(:user) }

  describe 'create user' do
    context 'when successful' do
      let(:user_params) { attributes_for(:user) }

      it 'creates user' do
        expect do
          User.create!(user_params)
        end.to change(User, :count).by 1
      end
    end

    context 'when missing email' do
      let(:user_params) { attributes_for(:user).merge!(email: '') }

      it 'does not create user record' do
        expect do
          User.create(user_params)
        end.not_to change(User, :count)
      end

      it 'returns errors' do
        record = User.new(user_params)
        record.save

        expect(record.errors.full_messages)
          .to eq ["Email can't be blank", 'Email is invalid']
      end
    end

    context 'when user already exists' do
      let(:user_params) do
        attributes_for(:user).merge(email: user.email)
      end

      it 'returns err message' do
        record = User.new(user_params)
        record.save

        expect(record.errors.full_messages).to eq ['Email has already been taken']
      end
    end

    context 'when password mismatch' do
      let(:user_params) do
        attributes_for(:user).merge(password: 'Another2120')
      end

      it 'returns err message' do
        record = User.new(user_params)
        record.save

        expect(record.errors.full_messages).to eq ["Password confirmation doesn't match Password"]
      end
    end

    context 'when password is invalid' do
      let(:user_params) do
        attributes_for(:user).merge(password: 'AnotherOne', password_confirmation: 'AnotherOne')
      end

      it 'returns err message' do
        record = User.new(user_params)
        record.save

        expect(record.errors.full_messages).to eq ['Password is invalid']
      end
    end

    context 'when email is invalid' do
      let(:user_params) do
        attributes_for(:user).merge(email: 'jamie.com')
      end

      it 'returns err message' do
        record = User.new(user_params)
        record.save

        expect(record.errors.full_messages).to eq ['Email is invalid']
      end
    end
  end
end
