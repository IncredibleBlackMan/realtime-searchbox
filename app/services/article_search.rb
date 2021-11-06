class ArticleSearch
  attr_reader :query

  def initialize(query: nil)
    @query = query.presence || '*'
  end

  def search
    search_metrics(query)
    search_results = Article.search(query)

    { articles: search_results.results }
  end

  def search_metrics(query)
    return if query == '*'

    text = SearchAnalytic.find_by('text LIKE ?', "#{query}%")

    if text.present?
      text.update(text: query)
    else
      SearchAnalytic.create(text: query, count: 1)
    end
  end
end
