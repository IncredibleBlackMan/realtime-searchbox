class ArticlesController < ApplicationController
  before_action :find_article, only: %i[show]
  def index
    @articles = Article.all

    render json: @articles, status: :ok
  end

  def show
    render json: @article, status: :ok
  end

  def create
    article = current_user.articles.new(article_params)

    if article.save
      render json: { article: article }, status: :created
    else
      render json: { errors: article.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.permit(
      :title,
      :introduction,
      :content
    )
  end
end
