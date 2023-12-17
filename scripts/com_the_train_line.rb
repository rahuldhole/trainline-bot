require 'mechanize'
require 'date'

class ComTheTrainLine
  attr_reader :local_settings

  def self.find(from, to, departure_at)
    cttl = ComTheTrainLine.new
    begin
      retry_count ||= 1
      cttl.bot(from, to, departure_at)
    rescue => e
      retry_count += 1
      return puts "Error: #{e.message}. Max retry reached. Please try again later. Exiting..." if retry_count > cttl.local_settings['MAX_RETRY'].to_i
      puts "Error: #{e.message}. Retrying in #{cttl.local_settings['RETRY_DELAY'].to_i} seconds..."
      sleep cttl.local_settings['RETRY_DELAY'].to_i
      cttl.new_user_agent
      retry
    end
  end
  
  def initialize
    @local_settings = {
      'DEFAULT_USER_AGENT' => 'Mac Safari',
      'RANDOMIZE_USER_AGENT' => true,
      'TRAINLINE_URL' => 'https://www.thetrainline.com/',
      'MAX_RETRY' => 3,
      'RETRY_DELAY' => 15,
    }

    @form_fields = {
      'from_name_match_string' => 'from.search_',
      'to_name_match_string' => 'to.search_',
      'departure_date_name' => 'page.journeySearchForm.outbound.title',
      'departure_time_name' => 'hours',
      'departure_minutes_name' => 'minutes',
      'submit_button_name' => 'search',
    }.freeze

    @agent = Mechanize.new
    new_user_agent

    puts "Initialized ComTheTrainLine"
    puts "> url: #{@local_settings['TRAINLINE_URL']}"
  end

  def method_missing(method, *args, &block)
    if method.to_s.end_with?('=')
      @local_settings[method.to_s.upcase.chop] = args.first
    elsif @local_settings.keys.include?(method.to_s.upcase)
      @local_settings[method.to_s.upcase]
    else
      super
    end
  end

  def new_user_agent(agent = nil)
    @agent.user_agent_alias = agent || (
      @local_settings['RANDOMIZE_USER_AGENT'] ? 
      Mechanize::AGENT_ALIASES.keys.sample : 
      @local_settings['DEFAULT_USER_AGENT']
    )
    puts "> user agent: #{@agent.user_agent}"
  end

  def bot(from, to, departure_at)
    puts "Searching for trips from #{from} to #{to} at #{departure_at}..."
    page = @agent.get(@local_settings['TRAINLINE_URL'])

    form = page.forms.first
    raise "Form not found." if form.nil?

    form = fill_form(form, from, to, departure_at)
    result_page = @agent.submit(form, form.buttons.last)

    puts "Submitted form... \n #{form.inspect}"
    File.open('form-filled.html', 'w') { |f| f.write(result_page) }
    # parse_results(result_page)
  end

  protected 

  def fill_form(form, from, to, departure_at)
    from_name, to_name = derive_from_to(form, departure_at)
    form[from_name] = from
    form[to_name] = to
    form[@form_fields['departure_date_name']] = departure_at.strftime('%d-%b-%y')
    form[@form_fields['departure_time_name']] = departure_at.strftime('%H')
    form[@form_fields['departure_minutes_name']] = departure_at.strftime('%M')
    form
  end

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
ComTheTrainLine.find('London', 'Paris', DateTime.new(2023, 12, 31, 17, 0, 0))
