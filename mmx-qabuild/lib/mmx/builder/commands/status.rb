require 'highline'
require 'yaml'

module MMX::Builder::Commands
  class Status
    def initialize(args)
      @args = args
    end
    
    def cli
      @cli ||= HighLine.new
    end
  
    def run!
      cli.say "\nCurrent QA branch status:\n\n"

      MMX::Builder.config['projects'].each do |project|
        cli.say "<%= color('#{project["name"]}', :green) %>"
        cli.say "-" * 76

        MMX::Builder.config["hosts"].each do |host|
          hostname = host['hostname']
          line = "| #{hostname}".ljust(20, " ")

          # Pulls both branchname and git-describe output, separated by a pipe character
          branchname, description = MMX::Builder::Inquirer.get_branch_and_description(project['path'], hostname)

          line << " | <%= color('#{branchname.to_s.ljust(16," ")}', :yellow) %>"
          line << " | <%= color('#{description.to_s.ljust(32," ")}', :yellow) %>"
          line << " |"

          cli.say line
        end
        cli.say "-" * 76
        cli.say "\n"
      end
      cli.say "\nTo change branches or refresh an environment, use 'qabuild build'.\n"
    end
  end
end