require 'socket'
require 'json'
require 'pg'

socket = TCPServer.new(80)

def query(term)
  """
  SELECT
    DISTINCT(geonames.geoname_id),
    geonames.name,
    geonames.feature_class,
    geonames.feature_code,
    geonames.country_code,
    geonames.admin1_code,
    geonames.admin2_code,
    geonames.population,
    geonames.timezone,
    feature_codes.feature_class_description,
    feature_codes.feature_code_description,
    admin_codes.name AS admin_code_name,
    countries_info.country
  FROM
    geonames
  JOIN
    feature_codes ON feature_codes.code = geonames.feature_class || '.' || geonames.feature_code
  LEFT JOIN
    admin_codes ON admin_codes.code = geonames.country_code || '.' || geonames.admin1_code
  JOIN
    countries_info ON countries_info.isocode = geonames.country_code
  WHERE
    to_tsvector('english', geonames.name || ' ' || geonames.alternate_names) @@ plainto_tsquery('english', '#{term}')
  ORDER BY
    geonames.population DESC
  LIMIT 5
  """
end

def search_results(term)
  conn = PG.connect(host: 'yacs-db', user: 'yacsdev',
                    password: 'yacsdev', dbname: 'yacs')

  result = conn.exec(query(term))

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
    result.inject(template) do |acc, (key, value)|
      acc = acc.gsub("{{#{key}}}", value || '')
      acc
    end
  end.join
end

loop do
  client     = socket.accept
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
