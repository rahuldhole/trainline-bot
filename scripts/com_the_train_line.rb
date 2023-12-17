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
      cttl.loading(cttl.local_settings['RETRY_DELAY'].to_i, "Retrying in #{cttl.local_settings['RETRY_DELAY'].to_i} seconds...")
      cttl.screenshot("error_retry_#{retry_count}")
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

    @agent = Mechanize.new
    new_user_agent

    loading(1, "Loading #{@local_settings['TRAINLINE_URL']}")
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
    loading(1, "User agent: #{@agent.user_agent}")
  end

  def bot(from, to, departure_at)
    loading(1, "Searching for trips from #{from} to #{to} at #{departure_at}...")
    page = @agent.get(@local_settings['TRAINLINE_URL'])

    form = page.forms.first
    raise "Form not found." if form.nil?

    form = fill_form(form, from, to, departure_at)
    results = @agent.submit(form, form.buttons.last)

    # puts "Submitted form... \n #{form.inspect}"
    screenshot("form_submitted", form.inspect)

    # puts "  Results page: #{results.inspect}"
    screenshot("results", results.inspect)
    # parse_results(result_page)
  end

  def screenshot(name=nil, html=nil)
    return if @agent.nil?
    html = @agent.page.body if html.nil?

    directory = "tmp"
    Dir.mkdir(directory) unless File.directory?(directory)

    name = Time.now.strftime("%Y-%m-%d_%H-%M-%S") if name.nil?
    filename = "screenshot_#{name.to_s}.html"
    filepath = "#{directory}/#{filename}" if not name.nil?

    File.open(filepath, 'w') { |f| f.write(html) }
    
    puts "screenshot saved to #{filename}"
    rescue => e
      puts "Session screenshot failed: #{e.message}"
  end

  def loading(seconds, msg=nil)
    spinner = %w[| / - \\]
    (seconds * 5).times do
      print "\u{1f50d} #{msg} #{spinner.rotate!.first}\r"
      sleep 0.2
    end
    print "\u{1f44d} #{msg}\n"
    puts
  end

  protected

  def fill_form(form, from, to, departure_at)
    from_name, to_name = derive_from_to(form, departure_at)
    form[from_name] = from
    form[to_name] = to
    form[@form_fields[:fixed]['departure_date_id']] = departure_at.strftime('%d-%b-%y')
    form[@form_fields[:fixed][:optional]['departure_hours_name']] = departure_at.strftime('%H')
    form[@form_fields[:fixed][:optional]['departure_minutes_name']] = departure_at.strftime('%M')
    
    form
  end

  def derive_from_to(form, departure_at)
    from_name = form.fields.find { |f| f.name.start_with?(@form_fields[:variable]['from_id_match_string']) }.name
    to_name = form.fields.find { |f| f.name.start_with?(@form_fields[:variable]['to_id_match_string']) }.name
    
    return from_name, to_name
  end

  def parse_results(page)
    # TODO
  end
end

# Example
ComTheTrainLine.find('London', 'Paris', DateTime.new(2023, 12, 31, 17, 0, 0))
