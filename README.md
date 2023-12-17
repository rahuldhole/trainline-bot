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
irb
from = "London"
to = "Paris"
depart_at = DateTime.new(2023, 12, 31, 17, 0, 0)
ComTheTrainLine.find(from, to, depart_at)

# ComTheTrainLine.find('London', 'Paris', DateTime.new(2023, 12, 31, 17, 0, 0))
~~~
