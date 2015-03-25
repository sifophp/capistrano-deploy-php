#
# Put here shared configuration shared among all children
#
# Read more about configurations:
# https://github.com/railsware/capistrano-multiconfig/blob/master/README.md

# First web frontal. This is the IP you get pinging sifo.me:
server '91.121.67.40', user: 'root', roles: %w{web}

# More servers? No problem:
# Second web frontal:
#server '192.168.33.11', user: 'root', roles: %w{web}

# Third web frontal:
#server '192.168.33.12', user: 'root', roles: %w{web}

# The application name is taken from the folder name:
set :application, proc { fetch(:stage).split(':').reverse[1] }

# Where your repository is:
set :repo_url, proc { "git@github.com:/sifophp/#{fetch(:application)}.git" }

# The final path where your code lives. Composer will add the folder "current". Change your VirtualHost according to this.
set :deploy_to, proc { "/home/www/#{fetch(:application)}" }

# Default branch is master, except if REVISION or BRANCH is passed.
# Example of a command:
# BRANCH=devel cap sifo-app:production deploy
set :branch, ENV["REVISION"] || ENV["BRANCH"] || "master"

# How many releases do you want to keep in the disc?
set :keep_releases, 15

set :scm, :git
set :format, :pretty
set :log_level, :info
set :pty, true



namespace :deploy do
  # When deploy finishes clean the OLD releases:
  after :finishing, 'deploy:cleanup'
  
  # After updating the server execute a dummy task (this is as an example, delete ):
  after :updated, 'deploy:dummy'
end
