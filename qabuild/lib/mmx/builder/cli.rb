class MMX::Builder::CLI
  def initialize(args)
    @args = args
    @args << '--help' if @args.empty?
    @command = args.shift
  end
  
  def command
    aliases = {
      "st" => "status",
      "b"  => "build",
      "switch" => "change",
      "refresh" => "rebuild"
    }
    
    aliases[@command] || @command
  end
  
  def run!
    begin
      run_command!
    rescue MMX::Builder::Commands::BadCommandError, MMX::Builder::Commands::DeprecationError => e
      puts "ERROR: #{e}"
    end
  end
  
  def run_command!
    case command
    when 'build'
      raise MMX::Builder::Commands::DeprecationError, 
      "The 'build' command is deprecated, please use 'rebuild' or 'change'; use --help for more info."
    when 'status'
      MMX::Builder::Commands::Status.new(@args).run!
    when 'rebuild'
      MMX::Builder::Commands::Rebuild.new(@args).run!
    when 'change'
      MMX::Builder::Commands::Change.new(@args).run!
    when 'version', '--version', '-v'
      display_version
    when 'help', '--help', '-h'
      display_help
    else
      raise MMX::Builder::Commands::BadCommandError, "The command #{command} is not understood."
    end
  end
  
  def display_version
    puts "Metromix QA Build Tool version #{MMX::Builder::VERSION}"
  end
  
  def display_help
      puts <<-HELP
Usage: qabuild COMMAND [ARGS]

Commands:
 status    Fetches and shows current branch status for all qa environments
 change    Change the branch being used for the given qa environment
 rebuild   Rebuilds the current branch for the given qa environment

HELP
  end
end