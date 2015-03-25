A Deployment recipe using Capistrano 3 (for php + composer)
==========================================================
When it comes to development we have historically used many systems. From manual `git pull`, `rsync` or `sftp` synchronization to `bash` or `python` scripts to name a few.

[Capistrano](http://capistranorb.com) is a remote server automation and deployment tool written in Ruby, but even if you are a PHP developer that should not scare you, there isn't much to learn if you want to start using Capistrano in your PHP project right away. It is a very handy and trustable tool when it comes to put code in production, no matter the language you use, and you definitely should give it a try.


## What does this deployment do?

**This project deploys a PHP application and installs its composer dependencies.** This is not specific of the SIFO framework, but we used the [sifo.me]() site as a simple example to deploy code.

Change the settings and you are good to go with your application.

This repository configures what we call an "Orchestrator", a machine that takes care of deploying the code in every single server and conducts the whole deployment process from the outside. You can of course use this code from your local machine to deploy if you'd like to.

If you run this code (and change the IP of the server with one of yours) you'll be deploying the site http://sifo.me in your own server. The deployment script works as follows:

- Connects via SSH to all the servers you configure under `config/deploy.rb`.
- Clones the code from the `:repo_url` variable (example repo is: https://github.com/sifophp/sifo-app)
- Once the code is cloned executes a `composer install` to resolve you php dependencies
- Leaves under the `current` directory (a symlink) the version of the deployed code.
- Executes the task `deploy:dummy` (which is a simple `ls`) to show you an example of recipe.


## Installation

In order to run Capistrano 3 you'll need at least Ruby version `1.9.3`. 

	# $ ruby -v
	# ruby 1.9.3

If Ruby >= 1.9.3 is installed:

	# Install the dependencies manager in the first place:
	sudo gem install bundler

	# Install:
	cd capistrano-deploy-php/
	bundle install

### Don't have Ruby 1.9.3?

**Note for CentOS users:**

When using `yum install ruby` an old version of Ruby will be suggested (1.8). That won't work. One way of installing Ruby 1.9.3 is using SCL (software collections). See this article on [https://digitalchild.info/centos-6-5-and-ruby1-9-3-via-software-collections/](how to install Ruby 1.9.3 in CentOS).


Summary:

    yum install -y centos-release-SCL
    yum install -y ruby193
    source /opt/rh/ruby193/enable

    # Make sure Ruby is used in the following reboots:
    echo "source /opt/rh/ruby193/enable" | sudo tee -a /etc/profile.d/ruby193.sh
    	

## Usage

The deployment paths, servers and variables are configured under `config/deploy.rb`. Set there the paths to your own project. If you want to test the deploy "as is" you only have to change the line:

 `server 'xx.xx.xx.xx', user: 'root'`

Use an IP and user of a machine you have access to and deploy!

In order to execute any of the following commands you have to be inside the directory

	cd capistrano-deploy-php/

##### See the list of tasks:

	bundle exec cap -T

##### Deploy an environment:
	
	# Deploy "production"
	bundle exec cap sifo-app:production deploy
	
	# Or directly:
	cap sifo-app:production deploy
	
	# Deploy "integration":
	cap sifo-app:integration deploy

##### Deploy to a specific branch

The production environment will deploy `master` while the integration environment will deploy the `devel` branch. Nevertheless you can at some point deploy using a different branch:

	BRANCH=devel cap sifo-app:production deploy

Of course this only work if the repository has a branch with such name.
 
##### Deploy a specific revision
You can also put the code in a specific commit:

	REVISION=09ae8eea884a14c14efeecdc73741e8485c5c4c3 cap sifo-app:production deploy

##### Add more environments:
Copy and paste any of the files `production.rb` or `integration.rb` to a new `whatever.rb`. Then deploy using:

	cap sifo-app:whatever deploy	
	
##### Adding more custom tasks
Create a `.cap` file under the `tasks/` folder. The file name is irrelevant, the task will be registered according to the name and namespace you give the test. See the  `tasks/dummy.cap` file. Execute it like this:

	cap sifo-app:production deploy:dummy


### Adding your own application

Copy and paste the folder `sifoweb` and write the name of your application. Set the needed parameters in the `config/` and you are ready to go.



### The Orchestrator needs SSH forwarding

This section is not specific of the code we show, but general concepts of working with SSH authentication.

When you modify this code and clone the source code of your own application the machine executing the command might need to read your own private repositories. If that's the case you'll need the deployed machines to have access to those servers.

Instead of adding each of the `id_rsa.pub` files of every server to your GitHub/Bitbucket/similar settings to grant them access, the easiest way to accomplish this is adding only the public SSH key of the "orchestrator" to your account and enable forwarding. Forwarding means that the other servers will use the key of the orchestrator.

In order to enable SSH forwarding in any linux-like (including Mac) system, you only need to do the following (do it in the Orchestrator):

    vi ~/.ssh/config

    # Write inside this file:
    ForwardAgent yes

You can check that your key is visible to ssh-agent by running the following command:

    ssh-add -L

If the command says that no identity is available, you’ll need to add your key:

    ssh-add ~/.ssh/id_rsa

On Mac OS X, ssh-agent will "forget" this key, once it gets restarted during reboots. But you can import your SSH keys into Keychain using this command:

    /usr/bin/ssh-add -K ~/.ssh/id_rsa

**Important**: Note that when you clone repositories **you must use git protocol** and NOT https.

#### Vagrant notes
If you want to test the Capistrano thing in a Vagrant machine, you need to have in your `Vagrantfile`:

    config.ssh.forward_agent = true


### Troubleshotting
If command "cap" is not found, make sure where the gem is installed and see if the path to the binary is inside the $PATH variable.

Otherwise add it:

    vi  /opt/rh/ruby193/enable
    # export PATH=/opt/rh/ruby193/root/usr/bin:/opt/rh/ruby193/root/usr/local/bin/${PATH:+:${PATH}}
    source /opt/rh/ruby193/enable



