source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'active_model_serializers', '~>0.9.4'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.0.4'
gem 'redis'
gem 'redis-rails'

gem 'devise'
gem 'omniauth-oauth2'
gem 'omniauth-strava'
# TODO: deprecated. change to strava-ruby-client
gem 'strava-api-v3'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'dotenv-rails'
  gem 'pry-byebug', platform: :mri
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
