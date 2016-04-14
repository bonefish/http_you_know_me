# require 'socket'
require './lib/server'

class Request

  attr_reader :guess, :body, :request_hash
  attr_reader :request_path, :request_type
  attr_accessor :request_lines
  
  def initialize
    @request_lines = []
    @request_hash = {}
    @request_path = nil
    @request_type = nil
  end

  def process_request(connection)
    read_header(connection)
    make_request_hash
    set_request_params
  end

  def set_request_params
    @request_path = request_hash["Path"]
    @request_type = request_hash["Verb"]
  end

  def read_header(connection)
    while line = connection.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    @request_lines
  end

  def make_request_hash()
    @request_lines.each_with_index do |line, index|
      if index == 0
        split_line = line.split(" ")
        @request_hash["Verb"] = split_line[0]
        @request_hash["Path"] = split_line[1]
        @request_hash["Protocol"] = split_line[2]
      else
        split_line = line.split(":", 2)
        @request_hash[split_line[0]] = split_line[1].lstrip
      end
    end
    @request_hash
  end

  def content_length
    @request_hash["Content-Length"].to_i
  end

  def read_body(connection)
    @body = connection.read(content_length)
  end

  def find_guess
    if @body
      @guess = body.split("=")[1].to_i
    else
      @guess = 0 #could be nil?
    end
  end

  def should_start_a_game
    @request_path == "/start_game"
  end
end
