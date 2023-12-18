FROM ruby:3

RUN apt-get update -y && \
    apt-get -y upgrade && \
    apt-get install -y libarchive-tools zip

# Workspace
RUN mkdir -p /home/trainline-bot
WORKDIR /home/trainline-bot

# Run bundler
COPY Gemfile* /home/trainline-bot/
RUN bundle install

# Copy rest of the source code into trainline-bot folder
COPY . /home/trainline-bot

# CMD ["bundle", "exec", "rspec", "spec"]
CMD ["irb"]
