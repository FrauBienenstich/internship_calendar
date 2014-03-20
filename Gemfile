source 'https://rubygems.org'
ruby "2.0.0"

gem 'rails', '4.0.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'icalendar'



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.1'
  gem 'coffee-rails', '~> 4.0.1'
  gem 'bootstrap-sass', '~> 3.1.1'
  gem "font-awesome-rails"
  gem 'jquery-rails'
  gem 'uglifier', '>= 2.1.1'
end

group :test, :development do

  #gem "capybara"
  gem "poltergeist", "~> 1.4.0"
  gem "launchy"

  gem "guard-rspec"
  gem 'rspec-rails'

  gem "factory_girl_rails"
  gem "database_cleaner"

  gem 'quiet_assets'
end

group :production do
  gem 'rails_12factor'
end