require "uri"
require "json"
require "net/http"

url = URI("https://www.thetrainline.com/graphql")

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request["sec-ch-ua"] = "\"Not_A Brand\";v=\"8\", \"Chromium\";v=\"120\", \"Google Chrome\";v=\"120\""
request["x-platform-type"] = "web"
request["x-api-managedgroupname"] = "TRAINLINE"
request["x-app-version"] = "4.35.27635"
request["sec-ch-ua-mobile"] = "?0"
request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
request["Content-Type"] = "application/json"
request["Accept"] = "application/json"
request["conversationid"] = "helloWorld"
request["x-api-currencycode"] = "EUR"
request["x-client-name"] = "DesktopWeb"
request["sec-ch-ua-platform"] = "\"Linux\""
request["Sec-Fetch-Site"] = "same-origin"
request["Sec-Fetch-Mode"] = "cors"
request["Sec-Fetch-Dest"] = "empty"
request["host"] = "www.thetrainline.com"
request["Cookie"] = "CookieControl={\"necessaryCookies\":[\"UMB-XSRF-TOKEN\",\"country-cookie\"],\"optionalCookies\":{\"analytics\":\"accepted\"},\"statement\":{\"shown\":true,\"updated\":\"10/10/2019\"},\"consentDate\":1701898753771,\"consentExpiry\":90,\"interactedWith\":true,};context_id=helloWorld;"
request.body = JSON.dump({
  "operationName": "RoutePricingDataQuery",
  "doc_id": "151b7d57222e9328393764e8d7cace84", # fixed
  "variables": {
    "requestBody": {
      "destination": "urn:trainline:generic:loc:4916",
      "origin": "urn:trainline:generic:loc:182gb",
      "requestedCurrencyCode": {
        "requestedCurrencyCode": "EUR"
      },
      "timePeriod": "BYDAY",
      "start": "2023-12-20T00:00:00Z",
      "end": "2023-12-31T00:00:00Z"
    }
  }
})

response = https.request(request)
puts response.read_body