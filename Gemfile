source 'https://rubygems.org'
source 'https://rails-assets.org'
ruby "2.0.0"

gem 'rails', '4.0.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'icalendar'
gem 'tod', '~> 1.3.0'



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.1'
  gem 'coffee-rails', '~> 4.0.1'
  gem 'bootstrap-sass', '~> 3.1.1'
  gem "font-awesome-rails"
  gem 'jquery-rails'
  gem 'uglifier', '>= 2.1.1'
  gem 'rails-assets-moment'
  gem 'rails-assets-Eonasdan--bootstrap-datetimepicker'
end

group :test, :development do

  gem "pry"
  gem "pry-debugger"
  #gem "capybara"
  gem 'mysql2'
  gem "poltergeist", "~> 1.4.0"
  gem "launchy"

  gem 'rspec-rails'

  gem "factory_girl_rails"
  gem "database_cleaner"

  gem 'quiet_assets'
  gem 'simplecov', '~> 0.7.1', :require => false
end

group :production do
  gem 'rails_12factor'
end

gem 'unicorn'
