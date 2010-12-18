require 'mmx/builder'
require 'net/ssh'

module MMX::Builder
  class Inquirer
    module Commands
      def self.current_branch
        "git branch | awk 'NF > 1' | awk '{if ($1 = \"*\") print $2}'"
      end
      
      def self.git_description
        "git describe"
      end
    end
    
    def self.get_current_branch(app_directory, hostname)
      current_branch = ""
      
      host = MMX::Builder.config['hosts'].detect {|hash| hash['hostname'] == hostname}
      
      inquirer = new(hostname, host['username'], host['password'])
      inquirer.connect do |connection|
        connection.exec!("cd #{app_directory}; #{Commands.current_branch}") do |channel, stream, data|
          current_branch << data.strip
        end
      end
      
      return current_branch
    end
    
    def self.get_branch_and_description(app_directory, hostname)
      git_description = ""
      
      host = MMX::Builder.config['hosts'].detect {|hash| hash['hostname'] == hostname}
      
      inquirer = new(hostname, host['username'], host['password'])
      inquirer.connect do |connection|
        connection.exec!("cd #{app_directory}; echo \"`#{Commands.current_branch}`|`#{Commands.git_description}`\"") do |channel, stream, data|
          git_description << data.strip
        end
      end
      
      return git_description.split('|')
    end
    
    attr_reader :host, :user

    def initialize(host, user, password)
      @host = host
      @user = user
      @password = password
    end
    
    def connect
      Net::SSH.start(@host, @user, :password => @password, :forward_agent => true) do |connection|
        yield connection
      end
    end
  
  end
end
