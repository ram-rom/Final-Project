require_relative 'util'

module Lib
  class Compiler
    include Util

    def run
      error "Simple Scalar Dir Doesn't Exist, you need to run install first" unless Dir.exists?(@@SIMPLE_SCALAR_DIR)

      info "*** Compiling Started ***"

      cmd('rm', '-f', "#{@@SIMPLE_SIM_DIR}/*.o")

      @@SRC_FILES.each do |file|
        cmd('rm', '-f', "#{@@SIMPLE_SIM_DIR}/#{file}")
        cmd("cd #{@@SIMPLE_SIM_DIR} && ln -s #{@@SRC_DIR}/#{file}")
      end

      cmd('make', '-C', @@SIMPLE_SIM_DIR)

      info "*** Compiling Finished ***"
    end
  end
end

