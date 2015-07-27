require 'formula'

class Tractor < Formula
  homepage 'https://github.com/dstndstn/tractor'

  head 'https://github.com/dstndstn/tractor.git', :using => :git

  depends_on 'swig' => :build
  depends_on 'pkg-config' => :build
  depends_on 'astrometry.net'

  # from pip
  depends_on 'pyfits' => :python
  depends_on 'numpy' => :python

  # this formula includes python bindings
  depends_on :python => :recommended

  def install
    system "make"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def test
    system "python -c 'import tractor'"
  end
end
