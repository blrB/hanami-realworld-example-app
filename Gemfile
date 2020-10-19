source 'https://rubygems.org'

gem 'rake'
gem 'hanami',       '~> 1.3'
gem 'hanami-model', '~> 1.3'

gem 'sqlite3'

gem 'rubocop', require: false

gem 'jwt'
gem 'bcrypt'

group :development do
  # Code reloading
  # See: https://guides.hanamirb.org/projects/code-reloading
  gem 'shotgun', platforms: :ruby
  gem 'hanami-webconsole'

end

gem 'pry-byebug'

group :test, :development do
  gem 'dotenv', '~> 2.4'
end

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'factory_bot'
  gem 'simplecov'
end

group :production do
  # gem 'puma'
end
