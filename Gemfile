source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# 
gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'jquery-rails'
gem 'materialize-sass'

gem 'toastr-rails'
gem 'font-awesome-rails'
gem 'font-awesome-sass'

gem 'devise'

gem 'omniauth', '~> 1.7', '>= 1.7.1'
gem 'omniauth-google-oauth2', '~> 0.5.2'
gem 'omniauth-facebook', '~> 4.0'
gem 'omniauth-twitter', '~> 1.4'

gem 'recaptcha', require: 'recaptcha/rails'

gem 'figaro', '~> 1.1', '>= 1.1.1'

gem 'active_model_otp'
gem 'rqrcode'
gem 'barby'

gem 'activeadmin', '1.0.0'
gem 'ckeditor', '4.2.4'
gem 'carrierwave', '1.2.1'
gem 'fog', '1.42.0'
gem 'mini_magick', '4.8.0'
gem 'html_truncator', '0.4.1'
gem 'will_paginate', '3.1.6'

gem 'active_admin-sortable_tree', '~> 1.0'

gem 'aws-sdk', '~> 3.0', '>= 3.0.1'
gem 'paperclip', '~> 5.1'

gem 'babosa', '~> 1.0', '>= 1.0.2'

gem 'friendly_id', '5.2.1'

gem 'activemerchant', '~> 1.74'
gem 'twocheckout', '~> 0.4.0'

gem 'sidekiq', '5.0.0'
gem 'redis', '3.3.3'
gem 'redis-namespace', '1.5.3'
gem 'daemons', '~> 1.2', '>= 1.2.5'

gem 'whenever', :require => false

group :development do
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'countries'