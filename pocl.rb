require 'formula'

class Pocl < Formula
  homepage 'http://pocl.sourceforge.net'
  url 'http://pocl.sourceforge.net/downloads/pocl-0.9.tar.gz'
  sha1 'd6e30f3120c7952dec9004db1db91a11d08c7b74'

  depends_on 'pkg-config' => :build
  depends_on 'hwloc'
  depends_on 'llvm' => 'with-clang'
  depends_on "libtool" => :run

  # Check if ndebug flag is required for compiling pocl didn't work on osx.
  # https://github.com/pocl/pocl/pull/65
  patch do
    url "https://github.com/pocl/pocl/commit/fa86bf.diff"
    sha1 "10f3a3cebce0003cab921c0a201b5e521882c2bc"
  end

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--enable-direct-linkage",
                          "--disable-icd",
                          "--enable-testsuites=",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/'foo.cl').write <<-EOS.undent
      kernel void foo(int *in, int *out) {
        int i = get_global_id(0);
        out[i] = in[i];
      }
    EOS
    system "#{bin}/pocl-standalone -h head.h -o foo.bc foo.cl"
    system "\"#{Formula["llvm"].opt_bin}/llvm-dis\" < foo.bc | grep foo_workgroup"
    system "pkg-config pocl --modversion | grep #{version}"
  end
end
