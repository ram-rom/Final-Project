require 'optparse'

module Lib
  module CmdArgs
    @@PREDICTORS = ['nottaken', 'taken', 'bimod', 'perceptron', 'gshare', 'random']

    def self.parse(argv)
      command = []
      params  = {}

      argv << '-h' if argv.empty?

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: ram-rom [command] [options]"

        opts.on_head(help_header)

        opts.on('-i', '--install', "Command to install simple scalar") do
          command.push(:install)
        end

        opts.on('-c', '--compile', "Command to compile simple scaler") do
          command.push(:compile)
        end

        opts.on('-s', '--simple-test', "Command to run a simple test") do
          command.push(:test)
        end

        opts.on('-p', '--plan=<filename>', "Command to run benchmarks based on a planfile") do |planfile|
          command.push(:test)
          params[:planfile] = planfile

          abort "Error: plan'#{planfile}' doesn't exist" if ! Dir.exists?(planfile) && ! File.exists?(planfile)
        end

        opts.on('-a', '--analyze', "Command to collect statistics test runs") do
          command.push(:analyze)
        end

        opts.on('-d', '--title=<title>', "Name of the title of the plan execution") do |title|
          params[:title] = title
        end

        opts.on('-p', '--predictor=<type>', "Name of the branch predictor") do |predictor|
          params[:predictor] = extract_predictor(predictor)
        end

        opts.on_tail(help_footer)
      end

      parser.parse!(argv)

      abort "Error: You can only run one command at time" unless command.length == 1

      {
        command: command.first,
        params: params
      }
    end

    def self.extract_predictor(predictor)
      predictor ||= @@PREDICTORS.first
      abort "Error: predictor is not supported, should be one of: <#{@@PREDICTORS.join(', ')}>" unless @@PREDICTORS.include?(predictor)
      predictor
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

  --plan <planfile>
    Execute the plans given by the planfile.

  OPTIONS
  --predictor <string>
    The predictor to be used during the test run. Use this param with --simple-test.
    The default is #{@@PREDICTORS.first}. Possible values: <#{@@PREDICTORS.join(', ')}>

  --title <string>
    The title of the plan to run analysis on. Use this aparm with --analyze
TAIL
    end
  end
end

