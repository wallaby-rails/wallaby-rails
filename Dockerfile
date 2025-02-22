# Use an official Ruby runtime as the base image
FROM ruby:3.4.1

RUN apt-get update -qq && \
  apt-get install -y nodejs default-mysql-client postgresql-client && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .
RUN bundle install

EXPOSE 3000

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
