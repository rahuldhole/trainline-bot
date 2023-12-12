require 'mechanize'
require 'date'

class ComTheTrainLine
  def initialize
    @local_settings = {
      'DEFAULT_USER_AGENT' => 'Mac Safari',
      'RANDOMIZE_USER_AGENT' => true,
      'TRAINLINE_URL' => 'https://www.thetrainline.com/',
      'MAX_RETRY' => 3,
      'RETRY_DELAY' => 10,
    }.freeze

    @form_fields = {
      'from_name_match_string' => 'from.search_',
      'to_name_match_string' => 'to.search_',
      'departure_date_name' => 'page.journeySearchForm.outbound.title',
      'departure_time_name' => 'hours',
      'departure_minutes_name' => 'minutes',
      'submit_button_name' => 'search',
    }.freeze

    @agent = Mechanize.new
    @agent.user_agent_alias = @local_settings['RANDOMIZE_USER_AGENT'] ? Mechanize::AGENT_ALIASES.keys.sample : @local_settings['DEFAULT_USER_AGENT']

    puts "Initialized ComTheTrainLine"
    puts "> user agent: #{@agent.user_agent}"
    puts "> url: #{@local_settings['TRAINLINE_URL']}"
  end

  def self.find(from, to, departure_at)
    bot = ComTheTrainLine.new
    retry_count = 0
    begin
      bot.search(from, to, departure_at)
    rescue => e
      retry_count += 1
      if retry_count <= @local_settings['MAX_RETRY']
        puts "Error: #{e.message}. Retrying in #{@local_settings['RETRY_DELAY']} seconds..."
        sleep @local_settings['RETRY_DELAY']
        retry
      else
        puts "Error: #{e.message}. Max retry reached. Please try again later. Exiting..."
      end
    end
  end

  def search(from, to, departure_at)
    puts "Searching for trips from #{from} to #{to} at #{departure_at}..."
    page = @agent.get(@local_settings['TRAINLINE_URL'])

    form = page.forms.first
    raise "Form not found." if form.nil?

    from_name, to_name = derive_from_to(form, departure_at)
    form[from_name] = from
    form[to_name] = to
    form[@form_fields['departure_date_name']] = departure_at.strftime('%d-%b-%y')
    form[@form_fields['departure_time_name']] = departure_at.strftime('%H')
    form[@form_fields['departure_minutes_name']] = departure_at.strftime('%M')

    result_page = @agent.submit(form, form.buttons.last)
    
    puts "Submitted form... \n #{form.inspect}"
    File.open('tmp/tmp.html', 'w') { |f| f.write(result_page.body) }
    # parse_results(result_page)
  end

  private 

  def derive_from_to(form, departure_at)
    from_name = form.fields.find { |f| f.name.start_with?(@form_fields['from_name_match_string']) }.name
    to_name = form.fields.find { |f| f.name.start_with?(@form_fields['to_name_match_string']) }.name
    
    return from_name, to_name
  end

  def parse_results(page)
    # TODO
  end

end

# Example
ComTheTrainLine.find('London', 'Paris', DateTime.new(2023, 12, 26, 6, 0, 0))
