# http://blog.plataformatec.com.br/2010/02/monitoring-delayed-job-with-bluepill-and-capistrano/

# deploy credentials
set :user, "deploy"
set :deploy_to, "/home/deploy/#{application}"
set :use_sudo, false
set :rails_env, "production"
 
# Bluepill related tasks
after "deploy:update", "bluepill:quit", "bluepill:start"
namespace :bluepill do
  desc "Stop processes that bluepill is monitoring and quit bluepill"
  task :quit, :roles => [:app] do
    sudo "bluepill stop"
    sudo "bluepill quit"
  end
 
  desc "Load bluepill configuration and start it"
  task :start, :roles => [:app] do
    sudo "bluepill load /home/deploy/my_app/current/config/production.pill"
  end
 
  desc "Prints bluepills monitored processes statuses"
  task :status, :roles => [:app] do
    sudo "bluepill status"
  end
end