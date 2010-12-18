set :scm,             :git
set :use_sudo,        false
set :rails_env,       'qa'
set :build_timestamp, Time.now.strftime("%Y%m%d%H%M")

default_run_options[:pty]   = true
ssh_options[:forward_agent] = true

def _deploy_to
  fetch(:deploy_to, "/express/")
end

def current_path
  unless fetch(:gem_deploy, false)
    "#{_deploy_to}/current"
  else
    _deploy_to
  end
end

def release_path
  "#{_deploy_to}/current"
end

def shared_path
  "#{_deploy_to}/shared"
end

# Load lib tasks
Dir["#{File.dirname(__FILE__)}/lib/*.rb"].each    { |f| load f  }

# Load app/stage tasks
Dir["#{File.dirname(__FILE__)}/apps/*.rb"].each   { |f| load f  }
Dir["#{File.dirname(__FILE__)}/stages/*.rb"].each { |f| load f  }

task :deploy do
  transaction do
    gem_deploy = fetch(:gem_deploy, false)
    update_code
    unless gem_deploy
      prepare_static_files

      ## bundler : gem bundle ##
      run "cd #{current_path} && bundle unlock && bundle install"

      ## migrate ##
      run "cd #{current_path} ; rake db:migrate RAILS_ENV=#{rails_env}"
      
      update_cron
      
      # Search is disabled; all builds now rebuild ONLY the app
      # restart_search
      restart_apps
    end
  end
end

task :prepare_static_files do
  ## compress static files ##

  public_paths.each do |public_path|
    run "for ext in js html htm htc css txt; do for file in `find #{public_path} -iname \"*.${ext}\"`; do gzip -9 -c ${file} > ${file}.gz ; done ; done"
  end


  ## touch image files ##

  public_paths.each do |public_path|
    run "for ext in gif jpg png; do for file in `find #{public_path} -iname \"*.${ext}\"`; do touch -t #{build_timestamp} ${file} ; done ; done"
  end
end

task :restart_search do
  ### restart search ##
  #run "cd #{release_path} && RAILS_ENV=#{rails_env} rake search:stop"
  #sleep 2
  #run "cd #{release_path} && RAILS_ENV=#{rails_env} rake search:start"
end

task :restart_apps do
  ## restart apps ##
  
  app_paths.each do |app_path|
    mongrel_path = "#{app_path}/config/mongrel/#{rails_env}.yml"
    run "[ ! -f #{mongrel_path} ] || (mongrel_rails cluster::restart -C #{mongrel_path})"
  end
end

task :update_cron do
  paths = fetch(:whenever_roots, [])
  if !paths.empty?
    run "crontab -l > #{paths.first}/tmp/cron.backup; exit 0" # don't crash Capistrano if crontab is empty
    on_rollback { run "crontab #{paths.first}/tmp/cron.backup; exit 0" } # don't crash Capistrano if crontab was empty
    paths.each do |path|
      run "cd #{path}; multiserver_whenever #{rails_env}"
    end
  else
    puts "Not updating cron with whenever because 'whenever_roots' is not set"
  end
end