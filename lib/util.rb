module Lib
  module Util
    @@HOST              = "i386-*-gnu/linux"
    @@ROOT_DIR          = %x{git rev-parse --show-toplevel}.chomp
    @@SRC_DIR           = "#{@@ROOT_DIR}/src"
    @@TAR_DIR           = "#{@@ROOT_DIR}/tar_files"
    @@SIMPLE_SCALAR_DIR = "#{@@ROOT_DIR}/simplescalar"
    @@SIMPLE_SIM_DIR    = "#{@@SIMPLE_SCALAR_DIR}/simplesim-3.0/"
    @@SRC_FILES         = ['bpred.c', 'bpred.h']

    def compile_simple_sim
      @@SRC_FILES.each do |file|
        cmd('rm', '-f', "#{@@SIMPLE_SIM_DIR}/#{file}")
        cmd("cd #{@@SIMPLE_SIM_DIR} && ln -s #{@@SRC_DIR}/#{file}")
      end

      cmd('make', '-C', @@SIMPLE_SIM_DIR)
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

