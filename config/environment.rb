# Load the rails application
require File.expand_path('../application', __FILE__)

# Load the app's custom environment variables here, so that they are loaded before environments/*.rb
env_vars = File.join(Rails.root, 'config', 'env_vars.rb')
load(env_vars) if File.exist? env_vars

# Load the configuration file
path = Rails.root.join('config', 'config.yml')
if File.exist?(path)
  puts "

WARNING: The OSEM configuration file

#{path}

is deprecated. Please use the environment variables
explained in INSTALL.md instead.

There is a rake task to migrate your settings. For instance
to migrate your settings for production:

bundle exec rake data:migrate:config2dotenv RAILS_ENV=production

"
end

# Initialize the rails application
Osem::Application.initialize!
