require 'formula'

class Libtsnnls < Formula
  homepage 'http://www.jasoncantarella.com/'
  url 'http://www.jasoncantarella.com/downloads/libtsnnls-2.3.3.tar.gz'
  sha1 '31a7c60788fc224daded30d308e2b3b6682a8278'

  #depends_on :x11

  def install
    # ENV.j1  # if your formula's build system can't parallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
