class Coin3dPivy < Formula
  desc "Python bindings for coin3d"
  homepage "https://coin3d.github.io/"
  url "https://github.com/coin3d/pivy/archive/0.6.5.tar.gz"
  sha256 "16f2e339e5c59a6438266abe491013a20f53267e596850efad1559564a2c1719"
  license "ISC"
  head "https://github.com/coin3d/pivy.git"

  livecheck do
    url :stable
    regex(/^(\d+\.\d+\.\d+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "swig@3" => :build
  depends_on "coin3d-coin"
  depends_on "pyside"
  depends_on "python@3.9"

  def install
    system Formula["python@3.9"].opt_bin/"python3", "setup.py",
      "build", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}"
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
      from pivy.sogui import SoGui
      assert SoGui.init("test") is not None
    EOS
  end
end
