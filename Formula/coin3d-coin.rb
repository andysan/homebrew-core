class Coin3dCoin < Formula
  desc "OpenGL-based Open Inventor 2.1 API implementation"
  homepage "https://coin3d.github.io/"
  url "https://github.com/coin3d/coin/archive/Coin-4.0.0.tar.gz"
  sha256 "b00d2a8e9d962397cf9bf0d9baa81bcecfbd16eef675a98c792f5cf49eb6e805"
  license "BSD-3-Clause"
  head "https://github.com/coin3d/coin.git"

  livecheck do
    url :stable
    regex(/^Coin-(\d+\.\d+\.\d+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "boost"

  def install
    args = std_cmake_args + %w[
      -GNinja
      -DCMAKE_BUILD_TYPE=Release
      -DCOIN_BUILD_MAC_FRAMEWORK=OFF
      -DCOIN_BUILD_DOCUMENTATION=ON
      -DOIN_USE_CPACK=OFF
    ]

    # Create an empty directory for cpack to make the build system
    # happy. This is a workaround for a build issue on upstream that
    # was fixed in commit be8e3d57aeb5b4df6abb52c5fa88666d48e7d7a0 but
    # hasn't made it to a release yet.
    mkdir "cpack.d" do
      touch "CMakeLists.txt"
    end

    mkdir "cmakebuild" do
      system "cmake", "..", *args
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <Inventor/SoDB.h>
      int main() {
        SoDB::init();
        SoDB::cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lCoin", "-Wl,-framework,OpenGL", \
           "-o", "test"
    system "./test"
  end
end
