require_relative '../search'

class SearchController < Chespirito::Controller
  VIEWS_PATH = './app/views'

  def create
    results = Search.call(request.params['term'])
    template = view("#{VIEWS_PATH}/search/results.html")

    body = results.map do |result|
      result.inject(template) do |acc, (key, value)|
        acc = acc.gsub("{{#{key}}}", value || '')
        acc
      end
    end.join

    response.status = 200
    response.headers['Content-Type'] = 'text/html'
    response.body = body
  end
end
