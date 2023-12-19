require 'net/http'

proxy_host = '123.123.123.123'
proxy_port = '5010800'
proxy_user = 'username'
proxy_pass = 'password'

uri = URI.parse("https://api.ipify.org?format=json")
http = Net::HTTP.new('api.ipify.org', 80, proxy_host, proxy_port)

# Set the proxy credentials if necessary
http.proxy_user = proxy_user
http.proxy_pass = proxy_pass

# Make a request through the proxy
response = http.get('/')