require_relative 'errors'

module Lib
  module Util
    include Errors

    @@HOST              = "i386-*-gnu/linux"
    @@ROOT_DIR          = %x{git rev-parse --show-toplevel}.chomp

    @@TAR_DIR           = "#{@@ROOT_DIR}/tar_files"
    @@SIMPLE_SCALAR_DIR = "#{@@ROOT_DIR}/simplescalar"
    @@SIMPLE_SIM_DIR    = "#{@@SIMPLE_SCALAR_DIR}/simplesim-3.0"
    @@SRC_DIR           = "#{@@ROOT_DIR}/src"

    @@SRC_FILES         = ['bpred.c', 'bpred.h']

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

    def self.help_header
      "\nSYNOPSIS"
    end

    def self.help_footer
<<-TAIL

DESCRIPTION
  These are the options you can pass to ram-rom. You can only run one command at a time.
  Some commands have extra options.

  COMMANDS
  --install
    This should only need to be done once or if you want a fresh install.

  --compile
    Run this each time you want to compile simple scalar with your changes.

  --simple-test
    Run this after you compile. This will run the benchmark test-math. This is used as a
    good sanity check that your code runs. Note this will output the statistics to stdout.

  --test <path>
    <path> can be a directory or a particular test. If <path> is a directory it will run
    each program in that directory under simplescalar. If <path> is file it will only run
    that program.

  PARAMS
  --name
    Name the current test run. Use this param with --test. This will create a directory under
    #{ENV['USER']}_test_runs. Each program run will be prefaced with the program name along with
    #runtime parameters.

TAIL
    end
  end
end

