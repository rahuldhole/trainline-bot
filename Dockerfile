# Use the official Ruby image as a base
FROM ruby:3.0

# Set the working directory in the container
WORKDIR /usr/app/trainline

# Copy Gemfile and Gemfile.lock to the container
COPY Gemfile ./

# Install dependencies (including gems)
RUN bundle install

# Copy the current project files to the container
COPY . .

# Load the Ruby script explicitly
# CMD ["ruby", "trainline_bot.rb"]

# IRB entry point
CMD ["irb", "-I", ".", "-r", "scripts/com_trainline.rb"]
