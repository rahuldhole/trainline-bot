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

  def self.test_make_json_post_request_with_headers
    url = URI("https://www.thetrainline.com/api/journey-search/")
    
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    
    request = Net::HTTP::Post.new(url)
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
    request["Cookie"] = "datadome=mysGPdCq2R2l9HQwVdflFyuRpCA3lanq45tWWdwkLP2mvj~fxRx8l~wPObk1cLaxRtj2kmOWv2TDW5m1Th5N~Gy2mZp5xwHviUpxU3VgIVF8DoPUuzOXaQNOJ~bMyZ88"
    request.body = JSON.dump({
      "passengers": [
        {
          "id": "efd67d6c-8a28-4ccc-8258-0b59e1ebed69",
          "dateOfBirth": "1990-12-18",
          "cardIds": []
        }
      ],
      "isEurope": true,
      "cards": [],
      "transitDefinitions": [
        {
          "direction": "outward",
          "origin": "urn:trainline:generic:loc:5306",
          "destination": "urn:trainline:generic:loc:827",
          "journeyDate": {
            "type": "departAfter",
            "time": "2023-12-22T14:15:00"
          }
        }
      ],
      "type": "single",
      "maximumJourneys": 5,
      "includeRealtime": true,
      "transportModes": [
        "mixed"
      ],
      "directSearch": false,
      "composition": [
        "through",
        "interchangeSplit"
      ]
    })
    
    response = https.request(request)
    puts response.read_body    
  end

end
