require_relative 'util'

module Lib
  class Test
    include Util
    include Errors

    def run(planfile: nil, predictor: 'taken')
      error "simplescalar directory doesn't exist, you need to run install first" unless Dir.exists?(@@SIMPLE_SCALAR_DIR)

      if planfile.nil?
        run_simple_test(predictor)
      else
        run_plans(planfile)
      end
    end

    private

    def run_plans(planfile)
      planfile = YAML.load_file(planfile)
      plans    = planfile[:plans]

      plans.each do |plan|
        execute_plan(plan)
      end
    end

    def execute_plan(plan)
      title          = plan[:title]
      predictors     = plan[:predictors]
      num_executions = plan[:num_executions]
      benchmarks     = plan[:benchmarks]

      error "you already executed this plan: #{title} - remove it or call it something else" if Dir.exists?(title)

      predictors.each do |predictor|
        info "Running #{predictor} benchmarks"
        num_executions.times do |i|
          info "  Iteration #{i + 1}"
          execute_benchmarks(predictor, benchmarks, title, i + 1)
        end
      end
    end

    def execute_benchmarks(predictor, benchmarks, title, iteration)
      failed    = 0
      total     = benchmarks.length
      rundir    = "#{@@ROOT_DIR}/plans/#{title}/#{predictor}/#{iteration}"
      errorfile = "#{rundir}/error.txt"

      cmd('mkdir', '-p', rundir)
      benchmarks.each do |benchmark|
        begin
          name    = benchmark[:name]
          args    = benchmark[:args]
          bname   = File.basename(name)
          outpath = "#{rundir}/#{bname}.run"

          info "    benchmark #{bname}"
          cmd(@@SIM_OUT_ORDER, '-bpred', predictor, name, args, '>', outpath, display_output: false)
        rescue CommandExecutionError => e
          failed += 1
          File.open(errorfile, 'a') { |file| file.write( "#{e}\n" ) }
        end
      end

      info "Run Complete. failed: #{failed}, successful: #{total - failed}, total: #{total}, errors: #{errorfile}"
    end

    def run_simple_test(predictor)
      info "Started Simple Math Test "
      cmd(@@SIM_OUT_ORDER, '-bpred', predictor, @@DEFAULT_TEST, display_cmd: true)
      info "Completed"
    end
  end
end

