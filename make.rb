class Make < Formula
  desc "Utility for directing compilation"
  homepage "https://www.gnu.org/software/make/"
  url "https://ftp.gnu.org/gnu/make/make-4.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/make/make-4.1.tar.bz2"
  sha256 "0bc7613389650ee6a24554b52572a272f7356164fd2c4132b0bcf13123e4fca5"
  revision 1

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
