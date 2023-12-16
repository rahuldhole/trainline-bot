require 'spec_helper.rb'

RSpec.describe 'simple tests', type: :feature do

  before(:each) do
    @session = BotSessions.create_bot_session('https://www.thetrainline.com')
  end

  after(:each) do
    BotSessions.end_bot_session(@session)
  end

  it 'Load home page' do
    @session.visit '/'
    @title = @session.title
    puts "Title: #{@title}"
  end

end
