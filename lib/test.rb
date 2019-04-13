require_relative 'util'

module Lib
  class Test
    include Util
    include Errors

    @@TEST_DIR = "#{ENV['USER']}_test_runs"

    def run(path: nil, name: nil, predictor: nil)
      error "simplescalar directory doesn't exist, you need to run install first" unless Dir.exists?(@@SIMPLE_SCALAR_DIR)

      if path.nil?
        run_simple_test
      else
        run_tests(path, name, predictor)
      end
    end

    private

    def run_tests(path, name, predictor)
      raise ArgumentError.new("Required arguments not present: path, name, and predictor") if !path || !name || !predictor

      test_run_dir = "#{@@TEST_DIR}/#{name}"
      error_file   = "#{test_run_dir}/errors.txt"

      error "#{name} already exists in #{@@TEST_DIR}. Delete these manually or rename your test run!" if Dir.exists?(test_run_dir)

      cmd('mkdir', '-p', test_run_dir)

      tests  = get_tests_from_path(path)
      failed = 0
      info "Running #{tests.count} tests for #{name}"
      tests.each_with_index do |test, index|
        begin
          program_name = File.basename(test)
          info "  #{index + 1} Running '#{program_name}'..."
          output_file = "#{test_run_dir}/#{program_name}.run", predictor
          cmd(@@SIM_OUT_ORDER, '-bpred', predictor, test, '>', output_file, display: false)
        rescue CommandExecutionError => e
          failed += 1
          File.open(error_file, 'a') { |file| file.write( "#{e}\n" ) }
        end
      end

      info "Completed - Failed: #{failed}, Successful: #{tests.count - failed}, Total: #{tests.count}"
      info "See #{error_file} for details" if failed > 0
    end

    def get_tests_from_path(path)
      tests = File.file?(path) ? [path] : Dir["#{path}/*"].select{ |f| File.file?(f) }
      tests.map { |t| "#{@@ROOT_DIR}/#{t}" }
    end

    def run_simple_test
      info "Started Simple Math Test "
      cmd(@@SIM_OUT_ORDER, @@DEFAULT_TEST)
      info "Completed"
    end
  end
end

