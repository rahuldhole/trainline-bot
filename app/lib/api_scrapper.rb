require 'uri'
require 'net/http'
require 'net/https'
require 'json'

module ApiScrapper
  # Define a method to handle GET requests
  def self.make_plain_get_request(base_url, params, spinner)
    url = URI.parse("#{base_url}?#{params}")
    response = Net::HTTP.get_response(url)

    return response.body if response.is_a?(Net::HTTPSuccess)

  rescue StandardError => e
    spinner.error
    puts "HTTP Request failed (#{e.message})".colorize(:red)
    return nil
  end

  # Define a method to handle POST requests
  def self.journey_search(json_data, spinners, spinner)
    url = URI("https://www.thetrainline.com/api/journey-search/")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    response = journey_search_request(https, request, json_data, cookie = nil)
    return response.body if response.is_a?(Net::HTTPSuccess)

    if response.code.to_i == 403
      captcha_url = "https://geo.captcha-delivery.com/captcha/"
      if response.body.include?(captcha_url)
        @spinner4 = spinners.register("[:spinner] Solving captcha...")
        sleep(1)
        extracted_captcha_url = response.body.match(/https:\/\/geo.captcha-delivery.com\/captcha\/.*?"/).to_s
        captcha_url = extracted_captcha_url[0..-2]

        puts "\nAfter solving the captcha, copy and paste the following script in your browser console to retrieve cookies:".colorize(:yellow)
        puts "   .scripts/cookie_retrieval.js".colorize(:blue)
        puts "Captcha URL: \n\n".colorize(:red)
        puts captcha_url.colorize(:blue)
        puts "\n\n\n"
        cookie = TTY::Prompt.new.mask("Please solve the captcha and paste the cookie here: ")
        puts "Thank you! Your cookie has been successfully received.".colorize(:green)

        response = journey_search_request(https, request, json_data, cookie)
        if response.is_a?(Net::HTTPSuccess)
          File.open(".datadome_cookies", "w") { |file| file.write(cookie) }
          @spinner4.success
          return response.body.force_encoding('UTF-8') 
        else
          @spinner4.error
          spinner.error
          puts "Response: #{response.inspect}".colorize(:red)
          puts "Journey search failed: #{response.body.force_encoding('UTF-8')}".colorize(:yellow)
          exit
        end
      end
    end

  rescue StandardError => e
    spinner.error
    puts "HTTP Request failed (#{e.message})".colorize(:red)
    return nil
  end

  def self.journey_search_request(https, request, json_data, cookie = nil)
    request["sec-ch-ua"] = "\"Not_A Brand\";v=\"8\", \"Chromium\";v=\"120\", \"Google Chrome\";v=\"120\""
    request["x-version"] = "4.35.27635"
    request["sec-ch-ua-mobile"] = "?0"
    request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    request["Content-Type"] = "application/json"
    request["accept"] = "application/json"
    request["sec-ch-ua-platform"] = "\"Linux\""
    request["Sec-Fetch-Site"] = "same-origin"
    request["Sec-Fetch-Mode"] = "cors"
    request["Sec-Fetch-Dest"] = "empty"
    request["host"] = "www.thetrainline.com"
    request["Cookie"] = cookie || File.read(".datadome_cookies") rescue nil

    request.body = json_data
    return https.request(request)
  end
end
