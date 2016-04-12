require 'socket'
require 'faraday'

class Response

  #remove, this was the experiment section of readme
  def experiment_response(request_lines)
    "<pre>" + request_lines.join("\n") + "</pre>"
  end

  def hello_response(count)
    "<pre>Hello, World!(#{count})</pre>"
  end

  def diagnostics_response(request_lines)
    "<pre>Verb: #{parse_verb(request_lines)}\nPath: #{parse_path(request_lines)}\nProtocol: #{parse_protocol(request_lines)}\nHost: #{parse_host(request_lines)}\nPort: #{parse_port(request_lines)}\nOrigin: #{parse_origin(request_lines)}\nAccept: #{parse_accept(request_lines)}\n</pre>"
  end

  def send_experiment_response(connection, request_lines)
    send_response(connection, experiment_response(request_lines))
  end

  def send_hello_response(connection, count)
    send_response(connection, hello_response(count))
  end

  def send_diagnostic_response(connection, request_lines)
    send_response(connection, diagnostics_response(request_lines))
  end

  def output_response_by_path(path, hello_count, request_count)
    response = id_response_by_path(path, hello_count, request_count)
  end

  def response_by_path(request_lines, path, hello_count, request_count)
    if path == "/"
      diagnostics_response(request_lines)
    elsif path == "/hello"
      hello_response(hello_count)
    elsif path =="/datetime"
      "#{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}"
    elsif path =="/shutdown"
      "Total requests: #{request_count}"
    else
      #???
    end
  end




  def send_response(connection, response)
    connection.puts headers(output(response))
    connection.puts output(response)
  end

  def output(response)
    "<html><head></head><body>#{response}</body></html>"
  end

  def headers(output)
    ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end


#change into hash; except first line, key is thing before first :
  def parse_verb(request_lines)
    request_lines[0].split(" ")[0]
  end

  def parse_path(request_lines)
    request_lines[0].split(" ")[1]
  end

  def parse_protocol(request_lines)
    request_lines[0].split(" ")[2]
  end

  def parse_host(request_lines)
    request_lines[1].split(":")[1].lstrip!
  end

  def parse_port(request_lines)
    request_lines[1].split(":")[2]
  end

  def parse_origin(request_lines)
    request_lines[1].split(":")[1].lstrip!
  end

  def parse_accept(request_lines)
    request_lines[4].split(":")[1].lstrip!
  end



end
