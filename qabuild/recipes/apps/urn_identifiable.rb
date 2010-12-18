namespace :urn_identifiable do
  task :default do
    set :repository,  "git@github.com:metromix/urn_identifiable.git"
    set :deploy_to, '/data/gems/urn_identifiable'

    set :user, 'express'
    set :password, 'XpR3$$'
    set :gem_deploy, true
  end
end
