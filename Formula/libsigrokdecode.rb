class Libsigrokdecode < Formula
  desc "Drivers for logic analyzers and other supported devices"
  homepage "https://sigrok.org/"
  license "GPL-3.0-or-later"
  revision 1

  stable do
    url "git://sigrok.org/libsigrokdecode",
        tag:      "libsigrokdecode-0.5.3",
        revision: "97991a3919da6a07c4c87308ae66fb441bd512e3"

    # Apply commit 9b0ad5177bd692f7556a4756bdbd2da81d9c34ce to add
    # support for Python 3.9.
    patch :DATA
  end

  livecheck do
    url :head
    regex(/^libsigrokdecode-(\d+(?:\.\d+)+)$/i)
  end

  head do
    url "git://sigrok.org/libsigrokdecode", branch: "master"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "python@3.9"

  def install
    system "./autogen.sh"
    mkdir "build" do
      system "../configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libsigrokdecode/libsigrokdecode.h>

      int main() {
        if (srd_init(NULL) != SRD_OK) {
           exit(EXIT_FAILURE);
        }
        if (srd_exit() != SRD_OK) {
           exit(EXIT_FAILURE);
        }
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libsigrokdecode").strip.split
    system ENV.cc, *flags, "test.c", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 5b432ea..4802f35 100644
--- a/configure.ac
+++ b/configure.ac
@@ -93,7 +93,7 @@ SR_PKG_CHECK_SUMMARY([srd_pkglibs_summary])
 # first, since usually only that variant will add "-lpython3.8".
 # https://docs.python.org/3/whatsnew/3.8.html#debug-build-uses-the-same-abi-as-release-build
 SR_PKG_CHECK([python3], [SRD_PKGLIBS],
-	[python-3.8-embed], [python-3.8 >= 3.8], [python-3.7 >= 3.7], [python-3.6 >= 3.6], [python-3.5 >= 3.5], [python-3.4 >= 3.4], [python-3.3 >= 3.3], [python-3.2 >= 3.2], [python3 >= 3.2])
+	[python-3.9-embed], [python-3.8-embed], [python-3.8 >= 3.8], [python-3.7 >= 3.7], [python-3.6 >= 3.6], [python-3.5 >= 3.5], [python-3.4 >= 3.4], [python-3.3 >= 3.3], [python-3.2 >= 3.2], [python3 >= 3.2])
 AS_IF([test "x$sr_have_python3" = xno],
 	[AC_MSG_ERROR([Cannot find Python 3 development headers.])])
 
