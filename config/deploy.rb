require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

set :domain, 'osem.seagl.org'
set :user, 'ubuntu'
set :deploy_to, '/srv/www/osem'
set :repository, 'https://github.com/seagl/osem.git'
set :term_mode, nil
set :rvm_path, '/usr/local/rvm/scripts/rvm'
set :rvm_use_path, '/usr/local/rvm/scripts/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, %w{ log public/system config/secrets.yml config/piwik.yml tmp .env.production}

task :environment do
  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby-2.3.0@default]'
end

task setup: :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/system"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/system"]
end

desc 'Deploys the current version to the server.'
task deploy: :environment do
  to :prepare do
    queue "cd #{deploy_to}/current && RAILS_ENV=production bin/delayed_job stop"
  end

  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'dump_db'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      queue "sudo systemctl restart apache2.service"
      # queue "cd #{deploy_to}/current && RAILS_ENV=production bin/delayed_job start"
    end

    invoke :'deploy:cleanup'
  end
end

desc 'Back ups the database'
task :dump_db do
  queue "bundle exec rake dump_db"
end
