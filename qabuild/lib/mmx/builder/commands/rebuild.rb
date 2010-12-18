module MMX::Builder::Commands
  class Rebuild
    def initialize(args)
      if args.length > 2
        raise MMX::Builder::Commands::BadCommandError, "Rebuild only accepts a project name (affiliate) and a host_prefix (qa01); you used: #{args.join(' ')}"
      end
      @project_name, @host_prefix = args
    end
    
    def run!
      MMX::Builder::Commands::Build.new([@project_name, @host_prefix]).run!
    end
  end
end