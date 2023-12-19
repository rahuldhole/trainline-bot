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
  def self.journey_search(json_data)
    url = URI("https://www.thetrainline.com/api/journey-search/")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    response = journey_search_request(https, request, json_data, cookie = nil)
    return response.body if response.is_a?(Net::HTTPSuccess)

    if response.code.to_i == 403
      captcha_url = "https://geo.captcha-delivery.com/captcha/"
      if response.body.include?(captcha_url)
        extracted_captcha_url = response.body.match(/https:\/\/geo.captcha-delivery.com\/captcha\/.*?"/).to_s
        captcha_url = extracted_captcha_url[0..-2]
        puts "Captcha URL: #{captcha_url}".colorize(:yellow)
        cookie = TTY::Prompt.new.mask("Please solve the captcha and paste the cookie here: ")
        response = journey_search_request(https, request, json_data, cookie)
        if response.is_a?(Net::HTTPSuccess)
          return response.body.force_encoding('UTF-8') 
        else
          puts "Response: #{response.inspect}".colorize(:red)
          puts "Journey search failed: #{response.body.force_encoding('UTF-8')}".colorize(:yellow)
          exit
        end
      end
    end

  rescue StandardError => e
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
    request["Cookie"] = "datadome=~ZK_3QCGsXo29f5XPte52aDLl6ojnqRcv0Wl_AxudX1XZJCrMhrdrUgm9ScBe5~laNezVrCokoOhrmPIsO10EtFMTsyjycy5FMRm8gUhGDmZ3dDnPE8Z46~vB5BEcmA2; context_id=0bb1f012-bfc4-4288-9795-bce6654c57ea; pdt=ff8561d5-62cc-4e51-8289-dedb27d37919"
    request["Cookie"] = cookie if cookie
    request.body = json_data
    return https.request(request)
  end
end
