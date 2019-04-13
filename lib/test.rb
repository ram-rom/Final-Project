require_relative 'util'

module Lib
  class Test
    include Util

    def run(path: nil)
      if path.nil?
        run_simple_test
      else
        run_tests(path)
      end
    end

    def run_tests(path)
      cmd('mkdir', '-p', "#{ENV['USER']}_test_runs")
    end

    def run_simple_test
      info "*** Started Running Simple Math Test ***"
      cmd(@@SIM_OUT_ORDER, @@DEFAULT_TEST)
      info "*** Finished Running Simple Test ***"
    end
  end
end

