require 'formula'

# The wcstools-3.8.6 tarball seems to include a "Man" directory, and a
# "man -> Man" symlink.  On a typical cases-insensitive HFS+ Mac
# volume this causes trouble.  Tell "tar" not to extract the second
# "man".
class TarIgnoreDuplicates < CurlDownloadStrategy
  def stage
    safe_system '/usr/bin/tar', 'xkf', @tarball_path, '--exclude', '*/man'
    chdir
  end
end

class Wcstools < Formula
  homepage 'http://tdc-www.harvard.edu/wcstools/'
  url 'http://tdc-www.harvard.edu/software/wcstools/wcstools-3.8.6.tar.gz', :using => TarIgnoreDuplicates
  sha1 '2c42eb314d422ccd9c3f1999ac2642e9de480b4c'

  def install
    system "make", "-f", "Makefile.osx", "all"

    prefix.install "bin"
  end

  test do
    system "imhead 2>&1 | grep -q 'IMHEAD'"
  end
end
