require 'uri'
require 'net/http'
require 'net/https'
require 'json'

module ApiScrapper
  # Define a method to handle GET requests
  def self.make_plain_get_request(base_url, params)
    url = URI.parse("#{base_url}?#{params}")
    response = Net::HTTP.get_response(url)

    return response.body if response.is_a?(Net::HTTPSuccess)

  rescue StandardError => e
    puts "HTTP Request failed (#{e.message})".colorize(:red)
    return nil
  end

  # Define a method to handle POST requests
  def self.make_json_post_request(base_url, json_data)
    url = URI.parse(base_url)
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Post.new(url.path, { 'Content-Type' => 'application/json' })

    request.body = json_data.to_json
    response = http.request(request)

    return response.body if response.is_a?(Net::HTTPSuccess)
    
  rescue StandardError => e
    puts "HTTP Request failed (#{e.message})".colorize(:red)
    return nil
  end
end
