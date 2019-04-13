require_relative 'script_util'

module Lib
  class Installer
    include ScriptHelper

    @@HOST              = "i386-*-gnu/linux"
    @@ROOT_DIR          = ScriptHelper.root_dir
    @@TAR_DIR           = "#{@@ROOT_DIR}/tar_files"
    @@SIMPLE_SCALAR_DIR = "#{@@ROOT_DIR}/simplescalar"

    def run
      error "Simple Scalar Dir Exists, remove it first to install fresh" if Dir.exists?(@@SIMPLE_SCALAR_DIR)

      info "*** Installation Started ***"

      cmd('mkdir', @@SIMPLE_SCALAR_DIR)
      untar_files
      cmd('cp', "#{@@SIMPLE_SCALAR_DIR}/sslittle-na-sstrix/lib/*", "#{@@SIMPLE_SCALAR_DIR}/glibc-1.09")
      configure('binutils-2.5.2')
      cmd('make', '-C', "#{@@SIMPLE_SCALAR_DIR}/simplesim-3.0")
      configure('gcc-2.6.3')

      info "*** Installation Finished ***"
    end


    private

    def configure(dir)
      cmd("cd #{@@SIMPLE_SCALAR_DIR}/#{dir} && ./configure --host=#{@@HOST} --target=ssbig-na-sstrix --with-gnu-as --with-gnu-ld --prefix=../")
    end

    def untar_files
      tar_files = Dir["#{@@TAR_DIR}/*"]
      tar_files.each do |tf|
        cmd('tar', '-xvf', tf, '-C', @@SIMPLE_SCALAR_DIR)
      end
    end
  end
end

