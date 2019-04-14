require_relative 'util'

module Lib
  class Analyze
    include Util

    def run(filename: nil)
      error "Output file required, please use --out argument" if filename.nil?
      error "Analysis file already exists: #{filename}" if File.exists?(filename)

    end
  end
end

