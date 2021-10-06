class SigrokCli < Formula
  desc "Sigrok command-line interface to use logic analyzers and more"
  homepage "https://sigrok.org/"
  license "GPL-3.0-or-later"
  revision 1

  stable do
    url "git://sigrok.org/sigrok-cli",
        tag:      "sigrok-cli-0.7.2",
        revision: "b584f959edb788f1731d5a304badf241ac21bf65"
  end

  livecheck do
    url :head
    regex(/^sigrok-cli-(\d+(?:\.\d+)+)$/i)
  end

  head do
    url "git://sigrok.org/sigrok-cli", branch: "master"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigrok"

  def install
    system "./autogen.sh"
    mkdir "build" do
      system "../configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/sigrok-cli", "-L"
  end
end
