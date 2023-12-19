require "uri"
require "json"
require "net/http"

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
request["Cookie"] = "datadome=~ZK_3QCGsXo29f5XPte52aDLl6ojnqRcv0Wl_AxudX1XZJCrMhrdrUgm9ScBe5~laNezVrCokoOhrmPIsO10EtFMTsyjycy5FMRm8gUhGDmZ3dDnPE8Z46~vB5BEcmA2; context_id=0bb1f012-bfc4-4288-9795-bce6654c57ea; pdt=ff8561d5-62cc-4e51-8289-dedb27d37919"
request.body = JSON.dump({
  "passengers": [
    {
      "id": "93223e87-09cc-4d23-8df6-c421f114b50d",
      "dateOfBirth": "1990-12-19",
      "cardIds": []
    }
  ],
  "isEurope": true,
  "cards": [],
  "transitDefinitions": [
    {
      "direction": "outward",
      "origin": "urn:trainline:generic:loc:182gb",
      "destination": "urn:trainline:generic:loc:4916",
      "journeyDate": {
        "type": "departAfter",
        "time": "2023-12-21T05:00:00"
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
puts response.body

# at this poitn it may throw a Captcha URl you need to solve the capctha 
# by pasting javscript ../.scripts/cookie_retrieval.js into your console and copy the coookie
# into request["Cookie"] of the same previous request = Net::HTTP::Post.new(url) (Note: Don't recreate the request)
