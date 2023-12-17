require 'selenium-webdriver'

# example
from = "London"
to = "Paris"
depart_at = DateTime.new(2023, 12, 31, 17, 0, 0)

@local_settings = {
  'url' => 'https://www.thetrainline.com/',
}

@form_fields = {
  accept_cookies_button_id: 'onetrust-accept-btn-handler',
  variable: {
    'from_id_match_string' => 'from.search_',
    'to_id_match_string' => 'to.search_',
  },

  fixed: {
    'form_data_test' => 'ExtendedSearch',
    'departure_date_id' => 'page.journeySearchForm.outbound.title',
    'submit_type_button_data_test' => 'submit-journey-search-button',

    optional: {
      'hours_minutes_id' => 'journey-search-form-time-picker', # two inputs hours and minutes have a common id
      #! Note:  first hours is for departure and second hours is for return same for minutes
      'departure_hours_name' => 'hours', # so lets differentiate them by name
      'departure_minutes_name' => 'minutes', # same here
      'leaving_at_or_arriving_by_id' => 'before-after-dropdown',
    }
  }
}.freeze

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--disable-popup-blocking')
options.add_argument('--start-maximized')

# proxy = File.readlines('config/proxies.txt').map(&:chomp).sample
# puts "Proxy: #{proxy}"
# prefs = {
#   prompt_for_download: false,
#   default_directory: "C:\\Users\\rdhol\\AppData\\Local\\Google\\Chrome\\User Data\\Default"
# }
# options.add_argument("--proxy-server=#{proxy}")
# options.add_preference(:download, prefs)

options.add_argument('--disable-blink-features=AutomationControlled')
options.add_argument('--disable-infobars')
options.add_argument('--disable-notifications')
options.add_argument('--disable-extensions')
options.add_argument('--disable-gpu')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--no-sandbox')
options.add_argument('--ignore-certificate-errors')
options.add_argument('--allow-running-insecure-content')
options.add_argument('--disable-web-security')
options.add_argument('--disable-features=IsolateOrigins,site-per-process')
options.add_argument('--ignore-urlfetcher-cert-requests')
options.add_argument('--disable-features=site-per-process')
options.add_argument('--disable-site-isolation-trials')

options.add_argument('--user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"')

driver = Selenium::WebDriver.for :chrome, options: options

driver.navigate.to @local_settings['url']
sleep 10

# accept cookies
puts "Checking cookies overlay form..."
cookies_btn = driver.find_elements(id: @form_fields[:accept_cookies_button_id])
cookies_btn.click if cookies_btn.size > 0
sleep 5

# from
puts "Finding form..."
form = driver.find_element(css: "[data-test='#{@form_fields[:fixed]['form_data_test']}']")
puts "Form found: #{form}"

# fill from
puts "Filling from..."
from_input = form.find_element(css: "[id*='#{@form_fields[:variable]['from_id_match_string']}']")
puts "From input found: #{from_input}"
from_input.send_keys(from)
# press TAB and ENTER
from_input.send_keys(:tab)
from_input.send_keys(:enter)

sleep 5

# fill to
puts "Filling to..."
to_input = form.find_element(css: "[id*='#{@form_fields[:variable]['to_id_match_string']}']")
puts "To input found: #{to_input}"
to_input.send_keys(to)
from_input.send_keys(:tab)
from_input.send_keys(:enter)
sleep 5

# fill departure date
puts "Filling departure date..."
departure_date_input = form.find_element(id: @form_fields[:fixed]['departure_date_id'])
puts "Departure date input found: #{departure_date_input}"
departure_date_input.send_keys(depart_at.strftime('%d-%b-%y'))
sleep 5

# fill departure hours
puts "Filling departure hours..."
departure_hours_input = form.find_elements(css: "[name='#{@form_fields[:fixed][:optional]['departure_hours_name']}']")[0]
puts "Departure hours input found: #{departure_hours_input}"
departure_hours_input.send_keys(depart_at.strftime('%H'))
sleep 5

# fill departure minutes
puts "Filling departure minutes..."
departure_minutes_input = form.find_elements(css: "[name='#{@form_fields[:fixed][:optional]['departure_minutes_name']}']")[0]
puts "Departure minutes input found: #{departure_minutes_input}"
departure_minutes_input.send_keys(depart_at.strftime('%M'))
sleep 5

# submit
puts "Submitting..."
submit_btns = form.find_elements(tag_name: 'button')
submit_btns.each do |btn|
  puts "Button: #{btn.text}"
  puts "HTML: #{btn.attribute('innerHTML')}"
  if btn.text == "Get cheapest tickets"
    btn.click
    sleep 10
  end
end

# save the resulted html page
puts "Saving the page..."
File.open('page.html', 'w') { |file| file.write(driver.page_source) }
sleep 120


driver.quit
