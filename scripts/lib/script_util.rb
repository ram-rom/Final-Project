module Lib
  module ScriptHelper
    def self.root_dir
      @@ROOT_DIR ||= %x{git rev-parse --show-toplevel}.chomp
    end

    def info(msg)
      puts "#{msg}\n"
    end

    def error(msg)
      abort "Error: #{msg}"
    end

    def cmd(*parts)
      cmd_str = parts.join(" ")
      output  = system("#{cmd_str} 2>&1")
      raise "\n\n\nError: '#{cmd_str}' failed with '#{output}'" unless $?.exitstatus == 0
      output
    end
  end
end

