namespace :deals do
  task :default do
    set :repository,  "git@github.com:metromix/deals.git"
    set :deploy_to, '/data/gems/deals'

    set :user, 'express'
    set :password, 'XpR3$$'

    set :gem_deploy, true
  end
end
