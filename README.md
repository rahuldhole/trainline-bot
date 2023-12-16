# Quickstart

### Setup containers
~~~
docker-compose build
docker-compose up -d chrome
docker-compose run --rm trainline-bot
docker-compose down
~~~

### Run code and tests
~~~
# Run tests
bundle exec rspec spec

# console
irb -I . -r config.rb
~~~