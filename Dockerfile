# Docker configuration for the application
FROM ruby:3.2.0

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  npm \
  redis-server \
  && rm -rf /var/lib/apt/lists/*

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy app code
COPY . .

# Expose port
EXPOSE 3000

# Start the server
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
