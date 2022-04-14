#!/bin/bash
set -e

# wait for database and tables
while ! (rake db:exists) do echo "waiting for database..."; sleep 2; done;

echo "executing start command ..."
bundle exec rails jobs:work
