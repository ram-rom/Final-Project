module Lib
  module Errors
    class CommandExecutionError < StandardError
      def initialize(cmd_str, output, exitstatus)
        msg = "\n\n\nError: command:'#{cmd_str}'\nexitstatus '#{exitstatus}'\noutput: '#{output}'\n\n"
        super(msg)
      end
    end
  end
end

