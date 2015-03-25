# All the configuration is in "deploy.rb". We only overwrite what is needed here.

# The integration environment uses the "devel" branch of the repository
set :branch, ENV["REVISION"] || ENV["BRANCH"] || "devel"

# Integration uses a different path since is installed in the same server:
set :deploy_to, proc { "/home/www/integration/#{fetch(:application)}" }