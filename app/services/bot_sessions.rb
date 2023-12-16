require 'capybara/dsl'
require 'capybara/rspec'
require 'nokogiri'
require 'webdrivers/chromedriver'
require 'cgi'

module BotSessions

  def self.create_bot_session(url)
    Capybara.app_host = url
    Capybara.run_server = false

    if ENV['CHROME_URL']
      Capybara.register_driver :remote do |app|
        Capybara::Selenium::Driver.new(app, browser: :remote, options: Selenium::WebDriver::Options.chrome, url: ENV['CHROME_URL'])
      end
      @session = Capybara::Session.new(:remote)
    else
      @session = Capybara::Session.new(:selenium_chrome)
    end
  end

  def self.end_bot_session(session)
    session.reset!
    session.driver.quit
  end

end