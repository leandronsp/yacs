require 'socket'

socket = TCPServer.new(80)

template = <<STR
<head>
  <style>
    h1 {
      color: red;
    }
  </style>
</head>

<h1>Hey, {{user_id}}!</h1>
<button>Change color to blue</button>

<script>
  function changeTitleColor() {
    let title = document.querySelector('h1');
    title.style.color = 'blue';
  }
  document.querySelector('button').addEventListener('click', changeTitleColor);
</script>
STR

loop do
  client        = socket.accept
  first_line    = client.gets
  verb, path, _ = first_line.split

  if verb == 'GET' && matched = path.match(/^\/customers\/(.*?)$/)
    user_id  = matched[1]
    body     = template.gsub("{{user_id}}", user_id)
    response = "HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n#{body}"

    client.puts(response)
  end

  client.close
end
