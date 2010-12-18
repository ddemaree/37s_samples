namespace :deals_mgmt do
  task :default do
    set :repository,  "git@github.com:metromix/deals-mgmt.git"
    set :deploy_to, '/data/deals-mgmt'

    set :user, 'express'
    set :password, 'XpR3$$'

    set :public_paths, %W(
      #{current_path}/public
    )

    set :app_paths, %W(
      #{current_path}
    )

    set :config_files, %W(
      config/*.yml
    )

    after  'update_code', 'deals_mgmt:copy_config_files'
  end
  
  task :copy_config_files do
    ## copy config files ##

    run "cp #{shared_path}/config/*.yml #{current_path}/config"
  end
end
