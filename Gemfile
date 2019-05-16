source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.0.4'
gem 'pg'
gem 'puma', '~> 3.0'

gem 'devise'
# gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth-strava'
gem 'figaro'
gem 'strava-api-v3'
gem 'active_model_serializers', '~>0.9.4'
gem 'redis'
gem 'redis-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
