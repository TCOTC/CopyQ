class Kf5Knotifications < Formula
  desc "Abstraction for system notifications"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.109/knotifications-5.109.0.tar.xz"
  sha256 "12b1b41c80739dcdda0cff1d81288323b8b5cb8249da45ecee4b785c604dc13d"
  head "https://invent.kde.org/frameworks/knotifications.git"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "copyq/kde/extra-cmake-modules" => [:build, :test]
  depends_on "copyq/kde/kf5-kconfig"
  depends_on "copyq/kde/kf5-kcoreaddons"
  depends_on "copyq/kde/kf5-kwindowsystem"
  depends_on "libcanberra"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DKDE_INSTALL_QTPLUGINDIR=lib/qt5/plugins"
    # setBadgeLabelText method is deprecated since 5.12
    args << "-DCMAKE_C_FLAGS_RELEASE=-DNDEBUG -DQT_DISABLE_DEPRECATED_BEFORE=0x050b00"
    args << "-DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG -DQT_DISABLE_DEPRECATED_BEFORE=0x050b00"

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Notifications REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
