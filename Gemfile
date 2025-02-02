source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'


# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# grape
gem 'grape'
gem 'grape_on_rails_routes'
gem 'grape-swagger'
gem 'grape-swagger-rails'

# devise 
gem 'devise'

# doorkeeper
gem 'doorkeeper'

# handle pagination 
gem 'kaminari'

# handle friendships
gem 'has_friendship'

# pg enumerators 
gem 'activerecord-postgres_enum'


# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# cqrs approach
gem 'rails_event_store'

# lighweight ruby gem for hashes
# (enables you specify datatypes and throws errors)
gem 'classy_hash'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

#Backgroud processes manager 
gem 'sidekiq'
# sidekiq UI
gem 'sinatra' 

# TAKE CARE OF THAT 
# redis -> place to store the jobs in development and production env 
gem 'redis-rails', '~> 5.0', '>= 5.0.2'
gem 'redis'

gem 'jsonapi-serializer'

# fake data for seed 
gem 'faker'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.9.1'
  gem 'factory_bot_rails'
  gem 'ruby_event_store-rspec'
  gem 'pry-byebug'
  
end

# it should be here 
group :test do 
  gem 'rspec-sidekiq'
  gem 'database_cleaner'
end 

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
