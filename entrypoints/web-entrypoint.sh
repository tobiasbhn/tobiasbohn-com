#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /application/tmp/pids/server.pid

echo "preparing tables ..."
# depends on custom db:exists Task to check if database exists (lib/tasks/db_exists.rake)
# Source: https://stackoverflow.com/a/35732641
while ! (rake db:exists) do
  echo "waiting for database...";
  sleep 2;
  rake db:exists && rake db:migrate || rake db:setup;
done;

echo "init spina database..."
rake spina:silent_first_deploy

echo "executing start command ..."
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
