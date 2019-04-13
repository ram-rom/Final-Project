module Lib
  module Util
    @@HOST              = "i386-*-gnu/linux"
    @@ROOT_DIR          = %x{git rev-parse --show-toplevel}.chomp
    @@TAR_DIR           = "#{@@ROOT_DIR}/tar_files"
    @@SIMPLE_SCALAR_DIR = "#{@@ROOT_DIR}/simplescalar"
    @@SIMPLE_SIM_DIR    = "#{@@SIMPLE_SCALAR_DIR}/simplesim-3.0/"
    @@SRC_DIR           = "#{@@ROOT_DIR}/src"
    @@SRC_FILES         = ['bpred.c', 'bpred.h']

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

