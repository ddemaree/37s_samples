module MMX::Builder::Commands
  class Change
    def initialize(args)
      @project_name, @host_prefix, @branch_name = args
      unless @branch_name
        raise MMX::Builder::Commands::BadCommandError, "You must specify a project name (affiliate), a host prefix (qa01), and a branch name"
      end
    end
    
    def run!
      MMX::Builder::Commands::Build.new([@project_name, @host_prefix, @branch_name]).run!
    end
  end
end