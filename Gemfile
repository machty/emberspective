source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-konacha'
  gem 'rb-fsevent', '~> 0.9'
end

group :test, :development do
  gem 'sqlite3'
  gem "rspec-rails", "~> 2.0"
  gem "rspec-mocks"
  gem "capybara"
  gem "capybara-webkit"
  gem "factory_girl_rails", "~> 4.2.0", require: false
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'konacha'
end

group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'ember-rails'
gem 'emblem-rails'

gem 'httparty'
gem 'bourbon'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
