require_relative 'util'

module Lib
  class Test
    include Util

    def run(path: nil)
      path ||= @@DEFAULT_TEST

      error "'#{path}' must point to a file" unless File.file?(path)

      info "*** Started Running Test for #{path} ***"
      cmd(@@SIM_OUT_ORDER, path)
      info "*** Finished Running Test ***"
    end
  end
end

