require 'optparse'
require 'capistrano'
require 'capistrano/cli'

module MMX::Builder::Commands
  class Build
    attr_reader :project_name, :host_prefix, :branch_name
    
    def initialize(args = [])
      @args = args
    end
    
    def run!
      validate_args!
      build!
    end
    
    def validate_args!
      parse_opts!
      @project_name, @host_prefix, @branch_name = @args
      validate_project_name!
      validate_host_prefix!
    end
    
    def build!
      cap.find_and_execute_task( project_name )
      cap.find_and_execute_task( host_prefix )
      cap.find_and_execute_task( :deploy )
    end
    
    def project_names
      @project_names ||= MMX::Builder.config['projects'].map {|project| project['name'] }
    end
    
    # qa01, qa02, etc.
    def host_prefixes
      @host_prefixes ||= MMX::Builder.config['hosts'].map {|host| host['hostname'].match(/^mxx([^\.]+)\./)[1] }
    end
    
    private
    
    def cap
      return @cap if @cap
      
      # Set up Capistrano
      @cap = Capistrano::Configuration.new
      @cap.logger.level = Capistrano::Logger::TRACE
      @cap.set(:password) { Capistrano::CLI.password_prompt }
      
      # Load cap recipes
      @cap.load MMX::Builder.recipes_dir.join('deploy.rb')
      
      # Set branch name to deploy
      if branch_name
        @cap.set :target_branch, branch_name
      end
      @cap
    end
    
    def validate_project_name!
      if !project_name
        raise MMX::Builder::Commands::BadCommandError, "You have to specify at least the app name (e.g. affiliate) and which environment\nyou want to build (e.g. qa01)."
      elsif !project_names.include?(project_name)
        raise MMX::Builder::Commands::BadCommandError, "Unrecognized project name (#{project_name}). Valid names: #{project_names.join(", ")}"
      end
    end
    
    def validate_host_prefix!
      if !host_prefixes.include?(host_prefix)
        raise MMX::Builder::Commands::BadCommandError, "Unrecognized host prefix (#{host_prefix}). Valid prefixes: #{host_prefixes.join(", ")}"
      end
    end
    
    def parse_opts!
      optparser = OptionParser.new do |opts|
        opts.banner = banner
      
        opts.on('-h', '--help', 'Display this screen') do
          display_help
        end
      end
      optparser.parse!(@args)
    end
    
    def display_help
      banner
    end
    
    def banner
      <<-BANNER
Usage: qabuild build [OPTIONS] PROJECT ENV_NAME [BRANCH]

Valid project names: #{project_names.join(", ")}
Valid environments:  #{host_prefixes.join(", ")}

BRANCH is required only when switching branches; if left blank, the build tool
will just re-build whatever branch is currently on the specified environment.
(If you want to know what branch is on a server, run 'qabuild status'.)

Options:
BANNER
    end
    
  end
end