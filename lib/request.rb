require 'socket'
require 'faraday'

class Request

  attr_reader :request_lines

  def read_request(connection)
    puts "Ready for a request"
    @request_lines = []
    while line = connection.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
  end

  def display_request
    puts "Got this request:"
    puts request_lines.inspect
  end

end
