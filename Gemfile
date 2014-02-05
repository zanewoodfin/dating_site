source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'
gem 'rb-readline', require: false
gem 'haml'
gem 'haml-rails'
# postgres database
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'
# login
gem 'devise'
gem 'simple_form'
# get user's timezone via javascript
gem 'browser-timezone-rails'
# allow for word style editing of text areas
gem 'tinymce-rails'
# pagination
gem 'will_paginate'
# bootstrap
gem 'bootstrap-will_paginate', git: 'git://github.com/yrgoldteeth/bootstrap-will_paginate.git'
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass'

gem 'newrelic_rpm'

gem 'geokit-rails'
gem 'area'

# images upload/resize
gem 'carrierwave'
gem 'rmagick'
gem 'fog'
gem 'unf'
gem 'carrierwave_direct'
gem 'sidekiq'
# amazon storage
gem 'aws-sdk'

group :development do
  gem 'quiet_assets'
  gem 'bullet', git: 'git@github.com:flyerhzm/bullet.git'
  gem 'airbrake'
  gem 'annotate'
  gem 'pry-rails'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'multi_test'
  gem 'capybara'
end

group :development, :test do
  gem 'railroady'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end

# Use unicorn as the app server
ruby '2.0.0'
