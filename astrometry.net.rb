require 'formula'

class AstrometryNet < Formula
  homepage 'http://astrometry.net'
  url 'http://astrometry.net/downloads/astrometry.net-0.43.tar.gz'
  sha1 'eef4cfe08b1366e9ee319cc9535a5657dec906d3'

  head 'http://astrometry.net/svn/trunk/src/astrometry', :using => :svn

  depends_on 'swig' => :build
  depends_on 'pkg-config' => :build
  depends_on 'wget'
  depends_on 'netpbm'
  depends_on 'cairo'
  depends_on 'jpeg'
  depends_on 'libpng'

  depends_on 'wcslib'

  # from pip
  depends_on 'pyfits' => :python
  depends_on 'numpy' => :python

  # this formula includes python bindings
  depends_on :python => :recommended

  option 'without-extras', "Don't try to build plotting code (actually it will still try, but homebrew won't halt the install if it fails)"
  option 'without-py', "Don't try to build python code"

  def install
    ENV['INSTALL_DIR'] = "#{prefix}"
    ENV['NETPBM_INC'] = "-I#{HOMEBREW_PREFIX}/include/netpbm"
    ENV['NETPBM_LIB'] = "-L#{HOMEBREW_PREFIX}/lib -lnetpbm"

    mkdir_p "#{HOMEBREW_PREFIX}/lib/python"
    # Argh, should make Astrometry.net install python to lib/python

    system "make"
    if not build.include? 'without-extras'
      system "make extra"
    end
    if not build.include? 'without-py'
      system "make py"
    end

    system "make install"

    if build.with? 'python':
      system "find #{prefix} > /tmp/1"
      system "mkdir -p #{prefix}/lib/python && mv #{prefix}/python #{prefix}/lib/"
    end

  end

  def test
    system "solve-field"
  end
end
