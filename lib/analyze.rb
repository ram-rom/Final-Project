require_relative 'util'
require 'csv'

module Lib
  class Analyze
    include Util

    def run
      plans = Dir["#{@@ROOT_DIR}/plans/*"]
      plans.each do |plan|
        title   = File.basename(plan)
        inpath  = "#{@@ROOT_DIR}/plans/#{title}"
        outpath = "#{@@ROOT_DIR}/analysis/#{title}"

        if File.exists?(outpath)
          info "Skipping analysis on plan named '#{title}' it already exists at '#{outpath}'"
          next
        end

        cmd('mkdir', '-p', outpath)

        stats     = gather_statistics(inpath)
        avg_stats = get_average(stats)

        generate_predictor_csv(outpath, avg_stats)
        generate_cumulative_csvs(outpath, avg_stats)
      end
    end

    private

    def generate_cumulative_csvs(path, results)
      [:miss_rate, :total].each do |stat|
        gen_csv = CSV.generate do |csv|
          headers = results.first[1].keys.sort.unshift("predictor") # predictor, b1, b2, b3, ...
          csv << headers
          predictors = results.keys.sort
          predictors.each do |predictor|
            row        = [predictor]
            benchmarks = results[predictor]
            benchmarks.keys.sort.each do |benchmark|
              row.push(benchmarks[benchmark][:miss_rate])
            end

            csv << row
          end
        end

        File.write("#{path}/#{stat}.csv", gen_csv)
      end
    end

    def generate_predictor_csv(path, results)
      results.each do |predictor, benchmarks|
        gen_csv = CSV.generate do |csv|
          csv << [:benchmark, :misses, :total, :miss_rate]

          benchmarks.keys.sort.each do |name|
            stats = benchmarks[name]
            csv << [name, stats[:misses], stats[:total], stats[:miss_rate]]
          end
        end

        File.write("#{path}/#{predictor}.csv", gen_csv)
      end
    end

    def get_average(stats)
      avg_stats = {}
      stats.each do |predictor, runs|
        avg_stats[predictor] = calculate_average(runs)
      end

      avg_stats
    end

    def calculate_average(runs)
      avg = {}

      # Total up
      runs.each do |run, benchmarks|
        benchmarks.each do |name, stats|
          avg[name] ||= { misses: 0, total: 0 }

          avg[name][:misses] += stats[:misses]
          avg[name][:total]  += stats[:total]
        end
      end

      # Divide by total runs
      num_runs = runs.keys.length
      avg.each do |benchmark, stats|
        avg[benchmark][:misses]    /= num_runs
        avg[benchmark][:total]     /= num_runs
        avg[benchmark][:miss_rate]  = (avg[benchmark][:misses].to_f / avg[benchmark][:total]).round(5)
      end

      avg
    end

    def gather_statistics(inpath)
      statistics = {}

      predictor_dirs = Dir["#{inpath}/*"]
      predictor_dirs.each do |pred_dir|
        predictor             = File.basename(pred_dir)
        statistics[predictor] = gather_predictor_stats(pred_dir)
      end

      statistics
    end

    def gather_predictor_stats(pred_dir)
      predictor_stats = {}
      run_dirs        = Dir["#{pred_dir}/*"]
      run_dirs.each do |run_dir|
        run_name                  = File.basename(run_dir)
        predictor_stats[run_name] = collect_benchmark_stats(run_dir)
      end
      predictor_stats
    end

    def collect_benchmark_stats(run_dir)
      benchmark_stats = {}
      run_files = Dir["#{run_dir}/*.run"]
      run_files.each do |run_file|
        benchmark = File.basename(run_file, '.run')
        benchmark_stats[benchmark] = collect_stats_from_benchmark(run_file)
      end

      benchmark_stats
    end

    def collect_stats_from_benchmark(run_file)
      total  = 0;
      misses = 0;
      current_line = nil
      File.open(run_file, 'r') do |file|
        file.each_line do |line|
          begin
            current_line = line
            if mline = line.match(/bpred_\w+.lookups\s+(\d+) # total.*/)
              total = mline.captures.first.to_i
            elsif mline = line.match(/bpred_\w+.misses\s+(\d+) # total.*/)
              misses = mline.captures.first.to_i
            end
          rescue ArgumentError => e
          end
        end
      end

      {
        misses: misses,
        total: total
      }
    end
  end
end

