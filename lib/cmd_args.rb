require 'optparse'

module Lib
  module CmdArgs

    def self.parse(argv)
      command = []
      params  = {}

      argv << '-h' if argv.empty?

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: ram-rom [command] [options]"

        opts.on_head(Lib::Util.help_header)

        opts.on('-i', '--install', "Command to install simple scalar") do
          command.push(:install)
        end

        opts.on('-c', '--compile', "Command to compile simple scaler") do
          command.push(:compile)
        end

        opts.on('-s', '--simple-test', "Command to run a simple test") do
          command.push(:test)
        end

        opts.on('-t', '--test=<path>', "Command to run a programs or directory of programs") do |path|
          command.push(:test)
          params[:path] = path

          abort "Error: path '#{path}' doesn't exist" if ! Dir.exists?(path) && ! File.exists?(path)
        end

        opts.on('-n', '--name=<name>', "Name of the test run") do |name|
          params[:name] = name
        end

        opts.on_tail(Lib::Util.help_footer)
      end

      parser.parse!(argv)

      abort "Error: You can only run one command at time" unless command.length == 1

      {
        command: command.first,
        params: params
      }
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

  OPTIONS
  --name
    Name the current test run. Use this param with --test. This will create a directory under
    #{ENV['USER']}_test_runs. Each program run will be prefaced with the program name along with
    #runtime parameters.

TAIL
    end
  end
end

