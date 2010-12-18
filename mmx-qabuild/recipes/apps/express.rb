namespace :express do
  task :default do
    set :repository,  "git@github.com:metromix/metromix-express.git"
    set :deploy_to, '/data/express'

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
    
    set :whenever_roots, [release_path]

    after  'update_code', 'express:copy_config_files'
  end
  
  task :set_env_vars do
    if fetch(:qa_env, nil)
      run "export EXPRESS_API_URI=http://www.#{qa_env}.mmx.local:9800 ; export METROMIX_URI=http://MARKET.#{qa_env}.mmx.local"
    end
  end
  
  task :check_env_vars do
    if fetch(:qa_env, nil)
      run "echo $EXPRESS_API_URI"
    end
  end
  
  task :copy_config_files do
    ## copy config files ##

    run "cp #{shared_path}/config/*.yml #{current_path}/config"
  end
end