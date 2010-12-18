require 'pathname'
require 'yaml'

module MMX
  module Builder
    module Commands
      class BadCommandError < ArgumentError; end
      class DeprecationError < ArgumentError; end
    end
    
    def self.build_root
      Pathname.new( ENV['BUILD_ROOT'] ||= File.dirname(__FILE__)+"/../../" )
    end
    
    def self.recipes_dir
      self.build_root.join("recipes")
    end
    
    def self.config
      @config ||= YAML.load(File.read(build_root + 'config.yml'))
    end
    
  end
end

require 'mmx/builder/version'
require 'mmx/builder/inquirer'
require 'mmx/builder/logger_enhancements'

require 'mmx/builder/commands/build'
require 'mmx/builder/commands/status'
require "mmx/builder/commands/rebuild"
require "mmx/builder/commands/change"