#!/usr/bin/env bash
#
# Entrypoint for the Wallaby development container.
#
# The repository is bind-mounted over /app, so gems are installed on first boot
# and re-checked whenever Gemfile/Gemfile.lock change. `bundle check` is a fast
# no-op once the bundle is satisfied.
set -euo pipefail

if [[ ! -f /app/Gemfile ]]; then
  echo 'No Gemfile found in /app - is the repository mounted?' >&2
  exit 1
fi

cd /app

if ! bundle check >/dev/null 2>&1; then
  echo 'Installing gems (this only happens on the first boot or when the Gemfile changes)...'
  bundle install
fi

exec "$@"
