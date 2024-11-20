class GeonamesController < Chespirito::Controller
  VIEWS_PATH = './app/views'

  def index
    response.status = 200
    response.headers['Content-Type'] = 'text/html'
    response.body = view("#{VIEWS_PATH}/search/form.html")
  end
end
