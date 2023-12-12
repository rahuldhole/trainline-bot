# Installation

~~~
docker build -t trainline .
~~~

### RUN
~~~
# Create a container
docker run -it --rm -v "$(pwd)":/usr/src/trainline -w /usr/src/trainline trainline

# In irb 
# irb -I . -r scripts/com_the_train_line.rb
ComTheTrainLine.find('London', 'Paris', DateTime.new(2023, 12, 31, 17, 0, 0))
~~~

#### Custom execution options
~~~
cttl = ComTheTrainLine.new
cttl.bot('London', 'Paris', DateTime.new(2023, 12, 31, 17, 0, 0))
~~~
##### Custom settings
~~~
# Set or get new settings
cttl.default_user_agent
cttl.default_user_agent="Mac Safari"
cttl.randomize_user_agent
cttl.randomize_user_agent=false
cttl.trainline_url="https://www.thetrainline.com/"
cttl.max_retry=2
cttl.retry_delay=20

cttl.local_settings

cttl.bot('London', 'Paris', DateTime.new(2023, 12, 31, 17, 0, 0))
~~~
##### Reset new user-agent
~~~
cttl.new_user_agent
~~~

# Troubleshoot
1. Trainline may block user-agent when too many requests scrapping the site
  > Use random user-agent or in worst case recreate the container
2. In order to avoid too many requests download the page for analysis
  ~~~
  # bash
  curl -s -o thetrainline.com.html https://www.thetrainline.com/

  # Use
  offline_analysis_page = 'thetrainline.com.html'
  page = @agent.get("file://#{File.expand_path(offline_analysis_page)}")
  ~~~
