FROM ruby:3.2.2

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     build-essential \
     libpq-dev \
     nodejs \
  && rm -rf /var/lib/apt/lists/*

# Copy Gemfile and lockfile early for caching
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler \
  && bundle config set deployment 'true' \
  && bundle config set without 'development' \
  bundle config unset frozen && \
  bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Expose the port that Puma binds to (default from ENV 'PORT')
EXPOSE 9292

# Default command: start Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
