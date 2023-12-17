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

# IRB entry point
CMD ["irb"]
