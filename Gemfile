source 'https://rubygems.org'

ruby '2.1.2'

gem 'rails', '~> 4.1.4'

gem 'exception_notification'
gem 'haml'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'sass-rails', '~> 4.0.3'
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'letter_opener'
  gem 'quiet_assets'
  gem 'capistrano', github: 'capistrano/capistrano'
  gem "capistrano-rails", github: "capistrano/rails"
end

group :test do
  gem 'capybara-webkit'
  gem 'capybara-email'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'shoulda-matchers'
end

group :development, :test do
  gem 'launchy'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'rspec'
  gem 'simple_bdd'
  gem 'rspec-rails'
end