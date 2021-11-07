class SearchAnalyticsController < ApplicationController
  def index
    @search_analytics = SearchAnalytic.all
  end
end
