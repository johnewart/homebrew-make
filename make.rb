class Make < Formula
  desc "Utility for directing compilation"
  homepage "https://www.gnu.org/software/make/"
  url "https://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/make/make-4.2.1.tar.bz2"
  sha256 "d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589"
  revision 1

  bottle do
    rebuild 3
    sha256 "c457485b491cccb4a03059e38244b14e7c7f54abb377fa31874848cc786b54ff" => :mojave
    sha256 "d1788bda69cb9fad4fa9225ee111503ff3b8dee37901878f380c3a27ee62b8f0" => :high_sierra
    sha256 "1d55b106718979c19a8e6ad9974fe9dbea6501daafcf0014e80143efd37dd74e" => :sierra
  end

  patch do
    url "https://raw.githubusercontent.com/osresearch/heads/make-4.2.1/patches/make-4.2.1.patch"
    sha256 "44781fb0f5c7f44bf3a6c105150edeae483af3b78d8cb7070c59b41122df8ea6"
  end
  
  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --program-prefix=g
    ]

    system "./configure", *args
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gmake" =>"make"
    (libexec/"gnuman/man1").install_symlink man1/"gmake.1" => "make.1"

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats; <<~EOS
    GNU "make" has been installed as "gmake".
    If you need to use it as "make", you can add a "gnubin" directory
    to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"
  EOS
  end

  test do
    (testpath/"Makefile").write <<~EOS
      default:
      \t@echo Homebrew
    EOS

    assert_equal "Homebrew\n", shell_output("#{bin}/gmake")
    assert_equal "Homebrew\n", shell_output("#{opt_libexec}/gnubin/make")
  end
end

__END__
--- clean/make-4.2/glob/glob.c	2013-10-20 17:14:38.000000000 +0000
+++ make-4.2/glob/glob.c	2018-09-18 10:16:03.860886356 +0000
@@ -208,7 +208,7 @@
 #endif /* __GNU_LIBRARY__ || __DJGPP__ */
 
 
-#if !defined __alloca && !defined __GNU_LIBRARY__
+#if !defined __alloca && defined __GNU_LIBRARY__
 
 # ifdef	__GNUC__
 #  undef alloca
