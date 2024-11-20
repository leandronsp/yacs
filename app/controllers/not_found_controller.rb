class NotFoundController < Chespirito::Controller
  def show
    response.status  = 404
    response.headers = { 'Content-Type' => 'text/html' }
    response.body    = '<h1>Not Found</h1>'
  end
end
