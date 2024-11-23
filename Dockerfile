FROM ruby:3.3.6 AS base
WORKDIR /app

FROM base AS production
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
COPY . .
CMD ["rackup"]
