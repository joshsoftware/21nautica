source 'https://rubygems.org'

ruby "2.1.2"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'
# Use postgres as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Simple helps you with powerful components to create your forms.
gem 'simple_form'

gem 'nested_form'
# State machines for Ruby classes, Read more: https://github.com/aasm/aasm
gem 'aasm', '~> 3.3'
# bootstrap-sass is a Sass-powered version of Bootstrap. Read more: https://github.com/twbs/bootstrap-sass
gem 'bootstrap-sass', '~> 3.2.0'

# Haml-rails provides Haml generators for Rails 4
gem 'haml-rails'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Espinita is an ORM extension that logs all changes to your models
gem "espinita", github: 'anilmaurya/espinita'

#Add a comment summarizing the current schema to the top of models
gem 'annotate', ">=2.6.0"

# Select2 is a jQuery based replacement for select boxes. It supports searching, remote data sets, and infinite scrolling of results.
gem "select2-rails"

# bootstrap-datepicker-rails project integrates a datepicker with Rails 3 assets pipeline.
gem 'bootstrap-datepicker-rails'

gem 'axlsx'

gem 'devise'
gem 'devise_invitable'
gem 'pdfkit', '~> 0.6.2'
gem 'numbers_in_words'

group :development do
  gem 'tlsmail'
  # Quiet Assets turns off the Rails asset pipeline log. Read more: https://github.com/evrone/quiet_assets
  gem 'quiet_assets'

  # better_errors and binding_of_caller show errors in html and can debug on html
  gem 'better_errors'
  gem 'binding_of_caller'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

end
# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
group :test do
  gem 'minitest-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'simplecov'
  gem 'faker', '~> 1.4.3'
  gem "codeclimate-test-reporter", require: nil
end
gem 'mocha'

group :production, :staging do
  gem 'rails_12factor'
  gem 'unicorn'
end
