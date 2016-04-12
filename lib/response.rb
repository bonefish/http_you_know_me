require 'socket'
require 'faraday'

class Response

  #remove, this was the experiment section of readme
  def build_response(connection, request_lines)
    puts "Sending response."
    response = "<pre>" + request_lines.join("\n") + "</pre>"
    #redesign all of these so this call doesnt happen here so i can isolate method for testing 
    #flip this around. call build_response in send response
    send_response(connection, response)
  end

  #do these stay now that further iterations don't use?
  def hello_world(connection, count)
    response = "<pre>Hello, World!(#{count})</pre>"
    send_response(connection, response)
  end

  #do these stay now that further iterations don't use?
  def output_diagnostics(connection, request_lines)
    response =  "<pre>Verb: #{parse_verb(request_lines)}\nPath: #{parse_path(request_lines)}\nProtocol: #{parse_protocol(request_lines)}\nHost: #{parse_host(request_lines)}\nPort: #{parse_port(request_lines)}\nOrigin: #{parse_origin(request_lines)}\nAccept: #{parse_accept(request_lines)}\n</pre>"
    send_response(connection, response)
  end

  def output_response_by_path(connection, path, hello_count, request_count)
    response = id_response_by_path(path, hello_count, request_count)
    send_response(connection, response)
  end

  def id_response_by_path(path, hello_count, request_count)
    if path == "/"
      response = "<pre>Verb: #{parse_verb(request_lines)}\nPath: #{parse_path(request_lines)}\nProtocol: #{parse_protocol(request_lines)}\nHost: #{parse_host(request_lines)}\nPort: #{parse_port(request_lines)}\nOrigin: #{parse_origin(request_lines)}\nAccept: #{parse_accept(request_lines)}\n</pre>"
    elsif path == "/hello"
      response = "<pre>Hello, World!(#{hello_count})</pre>"
    elsif path =="/datetime"
      response = "#{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}"
    elsif path =="/shutdown"
      response = "Total requests: #{request_count}"
    else
      #???
    end
    response
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
