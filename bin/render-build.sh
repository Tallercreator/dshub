#!/usr/bin/env bash
# Build script for Render — installs deps, builds assets, runs migrations.
set -o errexit

bundle install
bundle exec rails tailwindcss:build
bundle exec rails dartsass:build
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:prepare

# Load content seeds (idempotent: use find_or_initialize_by).
bundle exec rails runner db/seeds/all_cases.rb
bundle exec rails runner db/seeds/dodo_case.rb
bundle exec rails runner db/seeds/cases_content.rb
bundle exec rails runner db/seeds/all_terms.rb
bundle exec rails runner db/seeds/all_resources.rb
bundle exec rails runner db/seeds/new_reviews.rb
