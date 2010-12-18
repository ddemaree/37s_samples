version = File.read(File.expand_path("../../VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.name        = "mmx-qabuild"
  s.version     = version 
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["David Demaree", "Chris Powers"]
  s.email       = ["ddemaree@metromix.com", "cpowers@obtiva.com"]
  s.homepage    = "http://github.com/metromix/build_tools"
  s.summary     = "QA deploy tools for Metromix Rails apps"
  s.description = "Command-line interface for building Metromix QA environments."

  s.rubyforge_project = 'NA'
  s.required_ruby_version     = ">= 1.8.6"
  s.required_rubygems_version = ">= 1.3.6"

  # If you have other dependencies, add them here
  s.add_dependency "activesupport",  "~> 2.3.5"
  s.add_dependency "capistrano",     "~> 2.5.9"
  s.add_dependency "capistrano-ext", "~> 1.2"
  s.add_dependency 'highline',       '~> 1.5'
  s.add_dependency 'choice',         '~> 0.1'
  
  # Development dependencies
  s.add_development_dependency 'bundler',      '>= 0.9.25'
  s.add_development_dependency 'mmx-gemtools', '0.1.0'

  # If you need to check in files that aren't .rb files, add them here
  s.files = Dir["LICENSE", "*.md", "{lib}/**/*.rb", "recipes/**/*", "bin/*", "config.yml"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  s.executables = ["qabuild"]
end
