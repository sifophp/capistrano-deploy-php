# All the configuration is in "deploy.rb". We only overwrite what is needed here.

# Production environment uses the "master" branch of the repository. Use it if no environment var is present
set :branch, ENV["REVISION"] || ENV["BRANCH"] || "master"
set :repo_url, proc { "git@bitbucket.org:alombarte/#{fetch(:application)}.git" }

