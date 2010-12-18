require 'capistrano'

module Capistrano
  class Logger
  
    alias_method :log_without_terminal_output, :log
    
    def log(level, message, line_prefix=nil)
      if level <= self.level
        indent = "%*s" % [MAX_LEVEL, "*" * (MAX_LEVEL - level)]
        (RUBY_VERSION >= "1.9" ? message.lines : message).each do |line|
          if line_prefix
            pputs "#{indent} [#{line_prefix}] #{line.strip}\n"
            pputs "#{indent} [#{line_prefix}] #{line.strip}\n"
          else
            pputs "#{indent} #{line.strip}\n"
          end
        end
      end
    end
    
    def pputs(str)
      self.device.puts( str )
      if self.device != $stderr
        $stderr.puts( str )
      end
    end
  
  end
end