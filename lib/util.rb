require_relative 'errors'

module Lib
  module Util
    include Errors

    @@HOST              = "i386-*-gnu/linux"
    @@ROOT_DIR          = %x{git rev-parse --show-toplevel}.chomp

    @@TAR_DIR           = "#{@@ROOT_DIR}/tar_files"
    @@SIMPLE_SCALAR_DIR = "#{@@ROOT_DIR}/simplescalar"
    @@SIMPLE_SIM_DIR    = "#{@@SIMPLE_SCALAR_DIR}/simplesim-3.0"

    @@SIM_OUT_ORDER     = "#{@@SIMPLE_SIM_DIR}/sim-outorder"
    @@DEFAULT_TEST      = "#{@@SIMPLE_SIM_DIR}/tests-alpha/bin/test-math"

    def info(msg)
      puts "#{msg}\n"
    end

    def error(msg)
      abort "Error: #{msg}"
    end

    def cmd(*parts, display: true)
      cmd_str = parts.join(" ")

      output = if display
        system("#{cmd_str} 2>&1")
      else
        %x{#{cmd_str} 2>&1}
      end
      raise CommandExecutionError.new(cmd_str, output, $?.exitstatus) unless $?.exitstatus == 0
      output
    end
  end
end

