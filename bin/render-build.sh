#!/usr/bin/env bash
# Build script for Render — installs deps, builds assets, runs migrations.
set -o errexit

bundle install
bundle exec rails tailwindcss:build
bundle exec rails dartsass:build
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:prepare
