namespace :affiliate do
  task :default do
    set :repository,  "git@github.com:metromix/metromix.com.git"
    set :user, 'xtrovert'
    set :password, 'exv!@#$'
    set :deploy_to, '/data/extrovert'

    set :public_paths, %W(
      #{current_path}/metromix/public
      #{current_path}/cms/public
    )

    set :app_paths, %W(
      #{current_path}/metromix
      #{current_path}/cms
      #{current_path}/mobile
      #{current_path}/express-api
    )

    set :config_files, %W(
    )
    
    set :whenever_roots, ["#{release_path}/metromix", "#{release_path}/cms"]
    
    before 'restart_apps', 'affiliate:bundle_javascripts'
    after  'restart_apps', 'affiliate:restart_preview'
    
    after  'restart_apps', 'affiliate:restart_services'
    #after  'restart_apps', 'affiliate:restart_backgroundrb'
  end
  
  ## restart backgroundrb ##

  task :restart_backgroundrb do
    export_var = "export RAILS_ENV=#{rails_env}"
    run "#{current_path}/cms/script/backgroundrb stop -e #{rails_env}"
    run "#{export_var} ; nohup #{current_path}/cms/script/backgroundrb start -e #{rails_env}"
    run "#{current_path}/metromix/script/backgroundrb stop -e #{rails_env}"
    run "#{export_var} ; nohup #{current_path}/metromix/script/backgroundrb start -e #{rails_env}"
  end
  
  ## restart services ##

  task :restart_services do
    run "ruby #{current_path}/cms/daemon/bin/search_index.rb restart #{rails_env}"
    run "ruby #{current_path}/cms/daemon/bin/blog_post_daemon.rb restart #{rails_env}"
    run "ruby #{current_path}/cms/daemon/bin/geocoder.rb restart #{rails_env}"
  end
  
  task :restart_preview do
    mongrel_path = "#{current_path}/metromix/config/mongrel/preview_#{rails_env}.yml"
    run "[ ! -f #{mongrel_path} ] || mongrel_rails cluster::restart -C #{mongrel_path}"
  end
  
  ## bundle javascripts ##

  task :bundle_javascripts do
    run "cd #{current_path}/metromix; /usr/bin/env ruby lib/bundle_javascript.rb"
  end
end

