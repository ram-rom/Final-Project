require_relative 'util'

module Lib
  class Compiler
    include Util

    @@SRC_DIR   = "#{@@ROOT_DIR}/src"
    @@SRC_FILES = ['bpred.h', 'bpred.c', 'sim-outorder.c']

    def run
      error "simplescalar directory doesn't exist, you need to run install first" unless Dir.exists?(@@SIMPLE_SCALAR_DIR)

      info "Compiling Started"

      cmd('rm', '-f', "#{@@SIMPLE_SIM_DIR}/*.o")

      @@SRC_FILES.each do |file|
        cmd('rm', '-f', "#{@@SIMPLE_SIM_DIR}/#{file}")
        cmd("cd #{@@SIMPLE_SIM_DIR} && ln -s #{@@SRC_DIR}/#{file}")
      end

      cmd('make', '-C', @@SIMPLE_SIM_DIR)

      info "Completed"
    end
  end
end

