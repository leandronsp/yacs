require 'socket'
require 'json'
require 'pg'

socket = TCPServer.new(80)

def search_results(term)
  conn = PG.connect(host: 'yacs-db', user: 'yacsdev',
                    password: 'yacsdev', dbname: 'yacs')

  result = conn.exec("SELECT name,country_code,feature_class,feature_code FROM geonames WHERE to_tsvector('english', name || ' ' || alternate_names) @@ plainto_tsquery('#{term}') AND feature_class = 'P' ORDER BY population DESC limit 5")

  result.entries.map do |entry|
    entry.each_with_object({}) do |(key, value), acc|
      acc[key.to_sym] = value
    end
  end
end

def search_form_view
  File.read('./lib/views/search/form.html')
end

def search_results_view(term)
  template = File.read('./lib/views/search/results.html')
  results  = search_results(term)

  results.map do |result|
    template
      .gsub("{{name}}", result[:name])
      .gsub("{{country_code}}", result[:country_code])
      .gsub("{{feature_class}}", result[:feature_class])
      .gsub("{{feature_code}}", result[:feature_code])
  end.join
end

loop do
  client        = socket.accept
  first_line = client.gets

  verb, path, _ = first_line.split(' ')

  request = ''
  headers = {}
  body = ''
  params = {}

  while line = client.gets
    break if line == "\r\n"
    request += line

    if line.match(/.*?:.*?/)
      hname, hvalue = line.split(': ')
      headers[hname] = hvalue.chomp
    end
  end

  if content_length = headers['Content-Length']
    body = client.read(content_length.to_i)
    params = JSON.parse(body)
    request += "\n#{body}"
  end

  puts first_line
  puts request
  puts

  if verb == 'GET' && path == '/'
    client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n#{search_form_view}")
  elsif verb == 'POST' && path == '/search'
    client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n#{search_results_view(params['term'])}")
  else
    client.puts("HTTP/1.1 404\r\nContent-Type: text/html\r\n\r\n<p>Not Found</p>")
  end

  client.close
end
