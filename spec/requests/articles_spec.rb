require 'rails_helper'
require 'json_web_token'

RSpec.describe 'Articles', type: :request do
  let(:user) { create(:user) }
  let(:article) { create(:article) }

  before :each do
    Article.reindex
    # allow_any_instance_of(Rack::Test::CookieJar).to receive(:signed) { |object| object }
    # allow_any_instance_of(ActionDispatch::Cookies::CookieJar).to receive(:signed) { |object| object }
  end

  describe 'articles requests' do
    context 'when successful' do
      it 'returns article object' do
        set_cookie_headers

        post '/articles', params: article_params

        result = parse response

        expect(result['article']).to_not be_nil
        expect(response.status).to eq 201
      end
    end

    context 'when unsuccessful' do
      it 'returns error when user is unauthenticated' do
        post '/articles', params: article_params

        expect(response).to redirect_to('/login')
      end

      it 'returns error when title is empty' do
        set_cookie_headers

        post '/articles', params: article_params.merge(title: '')

        result = parse response

        expect(result['errors']['title']).to eq ['can\'t be blank']
        expect(response.status).to eq 422
      end

      it 'returns error when content is empty' do
        set_cookie_headers

        post '/articles', params: article_params.merge(content: '')

        result = parse response

        expect(result['errors']['content']).to eq ['can\'t be blank']
        expect(response.status).to eq 422
      end

      it 'returns error when introduction is empty' do
        set_cookie_headers

        post '/articles', params: article_params.merge(introduction: '')

        result = parse response

        expect(result['errors']['introduction']).to eq ['can\'t be blank']
        expect(response.status).to eq 422
      end
    end
  end

  describe 'article searches' do
    context 'when successful' do
      it 'returns articles object' do
        set_cookie_headers

        get "/articles?query=#{article.title}"

        expect(response).to render_template('index')
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

  def set_cookie_headers
    my_cookies = ActionDispatch::Request.new(Rails.application.env_config.deep_dup).cookie_jar
    my_cookies.signed[:jwt] = JsonWebToken.encode(user_id: user['id'])

    cookies[:jwt] = my_cookies[:jwt]
  end

  def parse(response)
    JSON.parse(response.body)
  end
end
