require_relative 'util'

module Lib
  class Installer
    include Util

    def run
      error "simplescalar directory exists, remove it first to install fresh" if Dir.exists?(@@SIMPLE_SCALAR_DIR)

      info "*** Installation Started ***"

      cmd('mkdir', @@SIMPLE_SCALAR_DIR)
      untar_files
      cmd('cp', "#{@@SIMPLE_SCALAR_DIR}/sslittle-na-sstrix/lib/*", "#{@@SIMPLE_SCALAR_DIR}/glibc-1.09")
      configure('binutils-2.5.2')
      cmd('make', '-C', @@SIMPLE_SIM_DIR)
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

