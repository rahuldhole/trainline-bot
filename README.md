# Quickstart

### Docker Installation
~~~
docker-compose build
docker-compose up -d chrome
docker-compose run --rm trainline-bot
docker-compose down
~~~
##### Monitor Dockerized Chrome using VNC Viewer 
~~~
localhost:5900
password: secret
~~~

### Ubuntu Latest Chromedriver Installation
~~~
apt-get install -y unzip xvfb libxi6 libgconf-2-4 jq libjq1 libonig5 libxkbcommon0 libxss1 libglib2.0-0 libnss3 \
  libfontconfig1 libatk-bridge2.0-0 libatspi2.0-0 libgtk-3-0 libpango-1.0-0 libgdk-pixbuf2.0-0 libxcomposite1 \
  libxcursor1 libxdamage1 libxtst6 libappindicator3-1 libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libxfixes3 \
  libdbus-1-3 libexpat1 libgcc1 libnspr4 libgbm1 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxext6 \
  libxrandr2 libxrender1 gconf-service ca-certificates fonts-liberation libappindicator1 lsb-release xdg-utils

LATEST_CHROME_RELEASE=$(curl -s https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json | jq '.channels.Stable')
LATEST_CHROME_URL=$(echo "$LATEST_CHROME_RELEASE" | jq -r '.downloads.chrome[] | select(.platform == "linux64") | .url')
wget -N "$LATEST_CHROME_URL" -P ~/
unzip ~/chrome-linux64.zip -d ~/
mv ~/chrome-linux64 ~/chrome
ln -s ~/chrome/chrome /usr/local/bin/chrome
chmod +x ~/chrome
rm ~/chrome-linux64.zip
~~~

##### Open Ruby console in Ubuntu
~~~
bundle install
irb -I . -r config/application.rb

# TO run tests
bundle exec rspec spec
~~~

# Run code and tests
~~~
# Run tests
bundle exec rspec spec

# console
irb
from = "London"
to = "Paris"
depart_at = DateTime.new(2023, 12, 31, 17, 0, 0)
ComTheTrainLine.find(from, to, depart_at)

# ComTheTrainLine.find('London', 'Paris', DateTime.new(2023, 12, 31, 17, 0, 0))
~~~
