require 'rails_helper'

RSpec.describe Article, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :introduction }
  it { should validate_presence_of :content }
  it { should validate_presence_of :status }

  let(:article) { create(:article) }
  let(:user) { create(:user) }

  describe 'create article' do
    context 'when successful' do
      let(:article_params) { attributes_for(:article) }

      it 'creates article' do
        expect do
          user.articles.create!(article_params)
        end.to change(Article, :count).by 1
      end
    end

    context 'when missing title' do
      let(:article_params) { attributes_for(:article).merge!(title: '') }

      it 'does not create user record' do
        expect do
          user.articles.create(article_params)
        end.not_to change(Article, :count)
      end

      it 'returns errors' do
        record = user.articles.new(article_params)
        record.save

        expect(record.errors.full_messages)
          .to eq ["Title can't be blank"]
      end
    end

    context 'when missing introduction' do
      let(:article_params) { attributes_for(:article).merge!(introduction: '') }

      it 'does not create user record' do
        expect do
          user.articles.create(article_params)
        end.not_to change(Article, :count)
      end

      it 'returns errors' do
        record = user.articles.new(article_params)
        record.save

        expect(record.errors.full_messages)
          .to eq ["Introduction can't be blank"]
      end
    end

    context 'when missing content' do
      let(:article_params) { attributes_for(:article).merge!(content: '') }

      it 'does not create user record' do
        expect do
          user.articles.create(article_params)
        end.not_to change(Article, :count)
      end

      it 'returns errors' do
        record = user.articles.new(article_params)
        record.save

        expect(record.errors.full_messages)
          .to eq ["Content can't be blank"]
      end
    end
  end
end
