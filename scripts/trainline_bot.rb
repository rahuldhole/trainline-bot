require 'mechanize'
require 'date'

class TrainlineBot
  def self.find(from, to, departure_at)
    agent = Mechanize.new

    # Set up your search parameters
    agent.get('http://thetrainline.com') do |page|
      form = page.form_with(action: '/search')
      form['from'] = from
      form['to'] = to
      form['departure_at'] = departure_at.strftime('%Y-%m-%dT%H:%M:%S%z')
      
      # Submit the search form
      page = form.submit
    end

    # Extract and parse the search results
    results = parse_results(agent.page)

    results
  end

  private

  def self.parse_results(page)
    # Implement your parsing logic here to extract relevant information from the page
    # You'll need to inspect the HTML structure of the search results page

    # For each trip segment, create a hash in the specified format and add it to the array
    segments = [
      {
        departure_station: 'Ashchurch For Tewkesbury',
        departure_at: DateTime.parse('2023-04-26T06:09:00+00:00'),
        arrival_station: 'Ash',
        arrival_at: DateTime.parse('2023-04-26T09:37:00+00:00'),
        service_agencies: ['thetrainline'],
        duration_in_minutes: 208,
        changeovers: 2,
        products: ['train'],
        fares: ['See below']
      },
      # Add more segments as needed
    ]

    # For each fare, create a hash in the specified format and add it to the array
    fares = [
      {
        name: 'Advance Single',
        price_in_cents: 1939,
        currency: 'GBP',
        comfort_class: 1,
      },
      # Add more fares as needed
    ]

    # Combine segments and fares into the final array
    segments.map { |segment| segment.merge(fares: fares) }
  end
end


# Example usage
#from = 'London'
#to = 'Paris'
#departure_at = DateTime.now

#results = TrainlineBot.find(from, to, departure_at)
#puts results
