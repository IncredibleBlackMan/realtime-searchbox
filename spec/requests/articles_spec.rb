require 'rails_helper'
require 'json_web_token'

RSpec.describe 'Articles', type: :request do
  let(:user) { create(:user) }
  let(:article) { create(:article) }

  before :each do
    Article.reindex
  end

  describe 'articles requests' do
    context 'when successful' do
      it 'returns article object' do
        post '/articles', params: article_params,
                          headers: { Authorization: "Token #{generate_auth_token}" }

        result = parse response

        expect(result['article']).to_not be_nil
        expect(response.status).to eq 201
      end
    end

    context 'when unsuccessful' do
      it 'returns error when user is unauthenticated' do
        post '/articles', params: article_params

        result = parse response

        expect(result['errors']).to eq 'You\'re not authorised to access this resource.'
        expect(response.status).to eq 401
      end

      it 'returns error when title is empty' do
        post '/articles', params: article_params.merge(title: ''),
                          headers: { Authorization: "Token #{generate_auth_token}" }

        result = parse response

        expect(result['errors']['title']).to eq ['can\'t be blank']
        expect(response.status).to eq 422
      end

      it 'returns error when content is empty' do
        post '/articles', params: article_params.merge(content: ''),
                          headers: { Authorization: "Token #{generate_auth_token}" }

        result = parse response

        expect(result['errors']['content']).to eq ['can\'t be blank']
        expect(response.status).to eq 422
      end

      it 'returns error when introduction is empty' do
        post '/articles', params: article_params.merge(introduction: ''),
                          headers: { Authorization: "Token #{generate_auth_token}" }

        result = parse response

        expect(result['errors']['introduction']).to eq ['can\'t be blank']
        expect(response.status).to eq 422
      end
    end
  end

  describe 'article searches' do
    context 'when successful' do
      it 'returns articles object' do
        get "/articles?query=#{article.title}",
            headers: { Authorization: "Token #{generate_auth_token}" }

        result = parse response
        binding.pry
        expect(result['articles']).to_not be_nil
        expect(response.status).to eq 200
      end
    end
  end

  def article_params
    {
      title: 'The title',
      introduction: 'The introduction',
      content: 'The content'
    }
  end

  def generate_auth_token
    JsonWebToken.encode(user_id: user['id'])
  end

  def parse(response)
    JSON.parse(response.body)
  end
end
