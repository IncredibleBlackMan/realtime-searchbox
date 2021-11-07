class ArticlesController < ApplicationController
  before_action :find_article, only: %i[show]

  def index
    @articles = ArticleSearch.new(
      query: params[:query],
      user: current_user
    ).search
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
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
