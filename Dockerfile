# Development image for the Wallaby monorepo.
#
# It ships the Ruby version pinned by the root Gemfile (`ruby '4.0.7'`) plus the
# native libraries required to build the `pg`, `mysql2`, `sqlite3` and `sassc`
# gems. Node and Yarn are included for the `wallaby` gem's asset build.
#
# The application code is *not* copied in: `docker-compose.yml` bind-mounts the
# repository over `/app` so edits are picked up live.
FROM ruby:4.0.7-slim

ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    GEM_HOME=/usr/local/bundle \
    PATH=/usr/local/bundle/bin:$PATH

# build-essential: native gem extensions (pg, mysql2, sqlite3, sassc, ...)
# default-libmysqlclient-dev / libpq-dev / libsqlite3-dev: headers for the
#   database adapters used by spec/dummy.
# git: the `simple_blog_theme` gem is sourced from GitHub.
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      default-libmysqlclient-dev \
      libpq-dev \
      libsqlite3-dev \
      libyaml-dev \
      pkg-config \
      git \
      curl \
      less \
      tzdata \
      nodejs \
      npm && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /app

ENTRYPOINT ["entrypoint.sh"]
# Keep the container alive so `docker compose exec app ...` can be used.
CMD ["sleep", "infinity"]
