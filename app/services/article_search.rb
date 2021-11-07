class ArticleSearch
  attr_reader :query, :user

  def initialize(query: nil, user: nil)
    @query = query.presence || '*'
    @user = user
  end

  def search
    search_metrics(query)
    search_results = Article.search(query)

    { articles: search_results.results }
  end

  def search_metrics(query)
    return if query == '*'

    sampled = []
    query_arr = query.split


    result_arr = user.search_analytics.where('text LIKE ?', "#{query_arr.first}%")

    counter = 0

    user.search_analytics.create(text: query, count: 1) and return unless result_arr.present?

    while counter < result_arr.length && sampled == []
      text = result_arr[counter].text

      text.split.each_with_index do |val, index|
        if val.eql?(query_arr[index])
          sampled << val
          break if query_arr[index].eql?(query_arr.last)
        elsif query_arr[index].eql?(query_arr.last) && val.eql?(query_arr[index].slice(0, val.length))
          sampled << val
          break if query_arr[index].eql?(query_arr.last)
        else
          sampled = []
          break
        end
      end

      counter += 1
    end

    user.search_analytics.create(text: query, count: 1) and return unless sampled.present?

    search_text = sampled.join(' ')

    analytic = user.search_analytics.find_by(text: search_text)

    analytic.update(text: query)
  end
end
